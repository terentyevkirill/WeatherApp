public class WeatherApiCalloutMock implements HttpCalloutMock {
    @TestVisible
    private static final String GET_CURRENT_SUCCESS = '{"location":{"name":"San Francisco","region":"California","country":"USA","lat":37.79,"lon":-122.4,"tz_id":"America/Los_Angeles","localtime_epoch":1667299729,"localtime":"2022-11-01 3:48"},"current":{"last_updated_epoch":1667299500,"last_updated":"2022-11-01 03:45","temp_c":14.4,"temp_f":57.9,"is_day":0,"condition":{"text":"Partly cloudy","icon":"//cdn.weatherapi.com/weather/64x64/night/116.png","code":1003},"wind_mph":9.4,"wind_kph":15.1,"wind_degree":210,"wind_dir":"SSW","pressure_mb":1011.0,"pressure_in":29.85,"precip_mm":0.0,"precip_in":0.0,"humidity":81,"cloud":75,"feelslike_c":13.4,"feelslike_f":56.2,"vis_km":16.0,"vis_miles":9.0,"uv":1.0,"gust_mph":12.8,"gust_kph":20.5}}';
    @TestVisible
    private static final String GET_CURRENT_ERROR = '{"error":{"code":1006,"message":"No matching location found."}}';

    private Integer statusCode;
    private String status;
    private String body;

    public WeatherApiCalloutMock(Integer statusCode, String status, String body) {
        this.statusCode = statusCode;
        this.status = status;
        this.body = body;
    }

    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(this.statusCode);
        res.setStatus(this.status);
        if (this.body != null) {
            res.setBody(this.body);
        }
        return res;
    }
}
