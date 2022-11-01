public with sharing class WeatherApiResponseWrapper {
    @AuraEnabled
    public LocationWrapper location;
    @AuraEnabled
    public CurrentWrapper current;
    @AuraEnabled
    public ForecastWrapper forecast;
    @AuraEnabled
    public ErrorWrapper error;

    public class LocationWrapper {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String region;
        @AuraEnabled
        public String localtime;
    }

    public class CurrentWrapper {
        @AuraEnabled
        public String last_updated;
        @AuraEnabled
        public Decimal temp_c;
        @AuraEnabled
        public Decimal temp_f;
        @AuraEnabled
        public ConditionWrapper condition;
        @AuraEnabled
        public Decimal feelslike_c;
        @AuraEnabled
        public Decimal feelslike_f;
        @AuraEnabled
        public Decimal wind_mph;
        @AuraEnabled
        public Decimal wind_kph;
        @AuraEnabled
        public Decimal precip_mm;
        @AuraEnabled
        public Decimal precip_in;
        @AuraEnabled
        public Decimal humidity;
    }

    public class ConditionWrapper { 
        @AuraEnabled
        public String text;
        @AuraEnabled
        public String icon;
    }

    public class ForecastWrapper {
        @AuraEnabled
        public List<ForecastDayWrapper> forecastday;
    }

    public class ForecastDayWrapper {
        @AuraEnabled
        public Long date_epoch;
        @AuraEnabled
        public DayWrapper day;
        @AuraEnabled
        public String dateT;
    }

    public class DayWrapper {
        @AuraEnabled
        public Decimal maxtemp_c;
        @AuraEnabled
        public Decimal maxtemp_f;
        @AuraEnabled
        public Decimal mintemp_c;
        @AuraEnabled
        public Decimal mintemp_f;
        @AuraEnabled
        public Decimal avgtemp_c;
        @AuraEnabled
        public Decimal avgtemp_f;
        @AuraEnabled
        public Decimal maxwind_mph;
        @AuraEnabled
        public Decimal maxwind_kph;
        @AuraEnabled
        public Decimal totalprecip_mm;
        @AuraEnabled
        public Decimal totalprecip_in;
        @AuraEnabled
        public Decimal avghumidity;
        @AuraEnabled
        public ConditionWrapper condition;
    }

    public class ErrorWrapper {
        @AuraEnabled
        public String message;
    }
}
