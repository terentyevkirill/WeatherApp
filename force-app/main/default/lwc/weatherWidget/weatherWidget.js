import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import weatherApiLogo from '@salesforce/resourceUrl/WeatherApiLogo';
import getForecastByZip from '@salesforce/apex/WeatherApiController.getForecastByZip';

export default class WeatherWidget extends LightningElement {

    @track zip;
    @track weatherData;
    @track isMetric = false;
    @track isLoading = false;
    @track activeSections = ['Current'];

    get logo() {
        return weatherApiLogo;
    }

    handleZipChange(event) {
        this.zip = event.target.value;
        this.template.querySelector('[data-id="zip"]').reportValidity();
    }

    handleMetricChange(event) {
        this.isMetric = event.target.checked;
    }

    handleGetForecastClick(event) {
        this.weatherData = undefined;
        this.isLoading = true;
        getForecastByZip({zip: this.zip})
            .then(result => {
                this.weatherData = result;
                this.isLoading = false;
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
                this.isLoading = false;
            });
    }

    handleSectionToggle(event) {

    }

    get isGetForecastDisabled() {
        return !(!this.isLoading && this.zip && this.template.querySelector('[data-id="zip"]') && this.template.querySelector('[data-id="zip"]').validity.valid);
    }

    get location() {
        if (this.weatherData && this.weatherData.location) {
            return this.weatherData.location.name + ', ' + this.weatherData.location.region;
        }
    }

    get temperature() {
        let result;
        if (this.weatherData && this.weatherData.current) {
            result = this.isMetric ? this.weatherData.current.temp_c : this.weatherData.current.temp_f;
            result += this.isMetric ? ' °C' : ' °F';
        }
        return result;
    }

    get feelsLike() {
        let result;
        if (this.weatherData && this.weatherData.current) {
            result = this.isMetric ? this.weatherData.current.feelslike_c : this.weatherData.current.feelslike_f;
            result += this.isMetric ? ' °C' : ' °F';
        }
        return result;
    }

    get precipation() {
        let result;
        if (this.weatherData && this.weatherData.current) {
            result = this.isMetric ? this.weatherData.current.precip_mm : this.weatherData.current.precip_in;
            result += this.isMetric ? ' mm' : ' in';
        }
        return result;
    }

    get humidity() {
        if (this.weatherData && this.weatherData.current) {
            return this.weatherData.current.humidity + '%';
        }
    }

    get wind() {
        let result;
        if (this.weatherData && this.weatherData.current) {
            result = this.isMetric ? this.weatherData.current.wind_kph : this.weatherData.current.wind_mph;
            result += this.isMetric ? ' kmph' : ' mph';
        }
        return result;
    }

    get weatherText() {
        if (this.weatherData && this.weatherData.current && this.weatherData.current.condition) {
            return this.weatherData.current.condition.text;
        }
    }

    get weatherIcon() {
        if (this.weatherData && this.weatherData.current && this.weatherData.current.condition) {
            return 'https:' + this.weatherData.current.condition.icon;
        }
    }

    get localTime() {
        if (this.weatherData && this.weatherData.location) {
            return this.weatherData.location.localtime;
        }
    }

    get lastUpdated() {
        if (this.weatherData && this.weatherData.current) {
            return this.weatherData.current.last_updated;
        }
    }

    get forecastData() {
        let forecastData = [];
        if (this.weatherData.forecast && this.weatherData.forecast.forecastday) {
            this.weatherData.forecast.forecastday.forEach(day => {
                let forecastday = {...day};
                forecastday.day.date = new Date(day.day.date_epoch).toString().substring(0, str.indexOf(' '));
                forecastData.push(forecastday);
            });
        }
        return forecastData;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title, message, variant
            })
        );
    }
}