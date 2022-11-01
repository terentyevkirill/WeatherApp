public with sharing class WeatherApiResponseWrapper {
    @AuraEnabled
    public LocationWrapper location;
    @AuraEnabled
    public CurrentWrapper current;
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

    public class ErrorWrapper {
        @AuraEnabled
        public String message;
    }
}
