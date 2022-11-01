public with sharing class WeatherApiService {
    private static final String CURRENT_ENDPOINT = 'http://api.weatherapi.com/v1/forecast.json?key={0}&q={1}&days=5'; 
    private static final String GET_METHOD = 'GET';
    private static final String UTF8_ENCODING_SCHEME = 'UTF-8';
    
    @TestVisible
    private static final String QUERY_PARAMETER_MISSING = 'Query parameter is missing.';
    @TestVisible    
    private static final String API_KEY_MISSING = 'API Key is missing. Check Weather API Config Custom Settings.';
    @TestVisible
    private static final String ENEXPECTED_STATUS_CODE = 'The status code returned was not expected: {0} {1}';

    public static WeatherApiResponseWrapper getCurrentWeather(String query) {
        if (String.isBlank(query)) {
            throw new WeatherApiException(QUERY_PARAMETER_MISSING);
        }
        WeatherApiConfig__c config = WeatherApiConfig__c.getInstance();
        if (config == null || String.isBlank(config.ApiKey__c)) {
            throw new WeatherApiException(API_KEY_MISSING);
        }
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            String.format(
                CURRENT_ENDPOINT,
                new String[]{
                    EncodingUtil.urlEncode(config.ApiKey__c, UTF8_ENCODING_SCHEME),
                    EncodingUtil.urlEncode(query, UTF8_ENCODING_SCHEME)
                }
            )
        );
        req.setMethod(GET_METHOD);
        HttpResponse res = sendRequest(req);
        WeatherApiResponseWrapper result = (WeatherApiResponseWrapper) JSON.deserialize(res.getBody(), WeatherApiResponseWrapper.class);
        return result;
    }

    private static HttpResponse sendRequest(HttpRequest req) {
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() != 200) {
            String errorMessage;
            try {
                WeatherApiResponseWrapper result = (WeatherApiResponseWrapper) JSON.deserialize(res.getBody(), WeatherApiResponseWrapper.class);
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
        return res;
    }

    public class WeatherApiException extends Exception { }
}
