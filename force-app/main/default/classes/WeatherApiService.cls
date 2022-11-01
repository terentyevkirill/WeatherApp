public with sharing class WeatherApiService {
    private static final String GET_METHOD = 'GET';
    private static final String UTF8_ENCODING_SCHEME = 'UTF-8';
    
    @TestVisible
    private static final String QUERY_PARAMETER_MISSING = 'Query parameter is missing.';
    @TestVisible    
    private static final String API_KEY_OR_ENDPOINT_MISSING = 'API Key or Endpoint is missing. Check Weather API Config Custom Settings.';
    @TestVisible
    private static final String ENEXPECTED_STATUS_CODE = 'The status code returned was not expected: {0} {1}';

    public static WeatherApiResponseWrapper getCurrentWeather(String query) {
        if (String.isBlank(query)) {
            throw new WeatherApiException(QUERY_PARAMETER_MISSING);
        }
        WeatherApiConfig__c config = WeatherApiConfig__c.getInstance();
        if (config == null || String.isBlank(config.ApiKey__c) || String.isBlank(config.Endpoint__c)) {
            throw new WeatherApiException(API_KEY_OR_ENDPOINT_MISSING);
        }
        HttpRequest req = createRequest(config, query);
        return sendRequest(req);
    }

    private static HttpRequest createRequest(WeatherApiConfig__c config, String query) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            String.format(
                config.Endpoint__c,
                new String[]{
                    EncodingUtil.urlEncode(config.ApiKey__c, UTF8_ENCODING_SCHEME),
                    EncodingUtil.urlEncode(query, UTF8_ENCODING_SCHEME)
                }
            )
        );
        req.setMethod(GET_METHOD);
        return req;
    }

    private static WeatherApiResponseWrapper sendRequest(HttpRequest req) {
        HttpResponse res = new Http().send(req);
        WeatherApiResponseWrapper result;
        if (res.getStatusCode() == 200) {
            result = (WeatherApiResponseWrapper) JSON.deserialize(res.getBody(), WeatherApiResponseWrapper.class);
        } else {
            String errorMessage;
            try {
                result = (WeatherApiResponseWrapper) JSON.deserialize(res.getBody(), WeatherApiResponseWrapper.class);
                if (result.error == null || String.isBlank(result.error.message)) {
                    throw new WeatherApiException();
                }
                errorMessage = result.error.message;
            } catch (Exception e) {
                errorMessage = String.format(
                    ENEXPECTED_STATUS_CODE, 
                    new String[]{
                        String.valueOf(res.getStatusCode()), 
                        res.getStatus()
                    }
                );
            }
            throw new WeatherApiException(errorMessage);
        }
        return result;
    }

    public class WeatherApiException extends Exception { }
}
