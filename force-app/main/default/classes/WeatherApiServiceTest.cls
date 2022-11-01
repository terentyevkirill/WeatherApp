@isTest
private class WeatherApiServiceTest {
    private static final String TEST_ZIP = '94105';
    private static final String TEST_API_KEY = '12345';

    static void setup() {
        WeatherApiConfig__c config = new WeatherApiConfig__c(ApiKey__c = TEST_API_KEY);
        insert config;
    }

    @isTest
    static void getCurrentWeatherQueryMissingErrorTest() {
        setup();
        Test.startTest();
        Exception ex;
        try {
            WeatherApiService.getCurrentWeather(null);
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();
        System.assertNotEquals(null, ex);
        System.assertEquals(WeatherApiService.QUERY_PARAMETER_MISSING, ex.getMessage());
    }

    @isTest
    static void getCurrentWeatherApiKeyMissingErrorTest() {
        Test.startTest();
        Exception ex;
        try {
            WeatherApiService.getCurrentWeather(TEST_ZIP);
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();
        System.assertNotEquals(null, ex);
        System.assertEquals(WeatherApiService.API_KEY_MISSING, ex.getMessage());
    }

    @isTest
    static void getCurrentWeatherApiErrorWithMessageTest() {
        setup();
        Test.setMock(HttpCalloutMock.class, new WeatherApiCalloutMock(400, 'Bad Request', WeatherApiCalloutMock.GET_CURRENT_ERROR));
        Test.startTest();
        Exception ex;
        try {
            WeatherApiService.getCurrentWeather(TEST_ZIP);
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();
        System.assertNotEquals(null, ex);
        System.assert(WeatherApiCalloutMock.GET_CURRENT_ERROR.contains(ex.getMessage()));
    }

    @isTest
    static void getCurrentWeatherApiErrorNoMessageTest() {
        setup();
        Test.setMock(HttpCalloutMock.class, new WeatherApiCalloutMock(400, 'Bad Request', '{}'));
        Test.startTest();
        Exception ex;
        try {
            WeatherApiService.getCurrentWeather(TEST_ZIP);
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();
        System.assertNotEquals(null, ex);
        System.assertEquals(
            String.format(
                WeatherApiService.ENEXPECTED_STATUS_CODE, 
                new String[]{
                    String.valueOf(400), 
                    'Bad Request'
                }
            ),
            ex.getMessage()
        );
    }

    @isTest
    static void getCurrentWeatherSuccessTest() {
        setup();
        Test.setMock(HttpCalloutMock.class, new WeatherApiCalloutMock(200, 'OK', WeatherApiCalloutMock.GET_CURRENT_SUCCESS));
        Test.startTest();
        WeatherApiResponseWrapper result = WeatherApiService.getCurrentWeather(TEST_ZIP);
        Test.stopTest();
        System.assert(result != null && result.current != null && result.location != null);
    }
}
