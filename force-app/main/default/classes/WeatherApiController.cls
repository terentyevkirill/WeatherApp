public with sharing class WeatherApiController {
    
    @AuraEnabled(cacheable=false)
    public static WeatherApiResponseWrapper getForecastByZip(String zip) {
        WeatherApiResponseWrapper result;
        try {
            result = WeatherApiService.getCurrentWeather(zip);
        } catch (Exception e) {
            AuraHandledException auraException = new AuraHandledException(e.getMessage());
            auraException.setMessage(e.getMessage());
            throw auraException;
        }
        return result;
    }
}
