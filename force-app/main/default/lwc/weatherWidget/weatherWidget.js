import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import weatherApiLogo from '@salesforce/resourceUrl/WeatherApiLogo';
import getForecastByZip from '@salesforce/apex/WeatherApiController.getForecastByZip';

export default class WeatherWidget extends LightningElement {

    @track zip;
    @track weatherData;
    @track isMetric = false;
    @track isLoading = false;

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
                console.log(JSON.stringify(result));
                this.weatherData = result;
                this.isLoading = false;
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
                this.isLoading = false;
            });
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

    get localTime() {
        if (this.weatherData && this.weatherData.location) {
            let date = new Date(this.weatherData.location.localtime_epoch * 1000);
            return this.formatDate(date);
        }
    }

    get lastUpdated() {
        if (this.weatherData && this.weatherData.current) {
            let date = new Date(this.weatherData.current.last_updated_epoch * 1000);
            return this.formatDate(date);
        }
    }

    formatDate(dateVal) {
        let newDate = new Date(dateVal);
        let sMonth = this.padValue(newDate.getMonth() + 1);
        let sDay = this.padValue(newDate.getDate());
        let sYear = newDate.getFullYear();
        let sHour = newDate.getHours();
        let sMinute = this.padValue(newDate.getMinutes());
        let sAMPM = 'AM';
        let iHourCheck = parseInt(sHour);
        if (iHourCheck > 12) {
            sAMPM = 'PM';
            sHour = iHourCheck - 12;
        } else if (iHourCheck === 0) {
            sHour = '12';
        }
        sHour = this.padValue(sHour);
        return sMonth + '/' + sDay + '/' + sYear + ' ' + sHour + ':' + sMinute + ' ' + sAMPM;
    }
    
    padValue(value) {
        return (value < 10) ? '0' + value : value;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title, message, variant
            })
        );
    }
}