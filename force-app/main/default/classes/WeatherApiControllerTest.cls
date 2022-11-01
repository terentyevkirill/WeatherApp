@isTest
private class WeatherApiControllerTest {
    private static final String TEST_ZIP = '94105';
    private static final String TEST_API_KEY = '12345';
    private static final String TEST_ENDPOINT = 'http://api.weatherapi.com/v1/current.json?key={0}&q={1}';

    @TestSetup
    static void setup() {
        WeatherApiConfig__c config = new WeatherApiConfig__c(
            ApiKey__c = TEST_API_KEY,
            Endpoint__c = TEST_ENDPOINT
        );
        insert config;
    }

    @isTest
    static void getForecastByZipErrorTest() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiCalloutMock(400, 'Bad Request', WeatherApiCalloutMock.GET_CURRENT_ERROR));
        Test.startTest();
        Exception ex;
        try {
            WeatherApiController.getForecastByZip(TEST_ZIP);
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();
        System.assertNotEquals(null, ex);
        System.assert(WeatherApiCalloutMock.GET_CURRENT_ERROR.contains(ex.getMessage()));
    }

    @isTest
    static void getForecastByZipSuccessTest() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiCalloutMock(200, 'OK', WeatherApiCalloutMock.GET_CURRENT_SUCCESS));
        Test.startTest();
        WeatherApiResponseWrapper result = WeatherApiController.getForecastByZip(TEST_ZIP);
        Test.stopTest();
        System.assert(result != null && result.current != null && result.location != null);
    }
}
