import { LightningElement, api, wire, track } from 'lwc';
import weatherApiLogo from '@salesforce/resourceUrl/WeatherApiLogo';


export default class WeatherWidget extends LightningElement {

    @track zip;
    @track weatherData;
    @track isLoading = false;

    get logo() {
        return weatherApiLogo;
    }

    handleZipChange(event) {
        this.zip = event.detail.value;
        this.template.querySelector('[data-id="zip"]').reportValidity();
    }

    handleGetForecastClick(event) {
        // this.isLoading = true;
    }

    get isGetForecastDisabled() {
        return !(!this.isLoading && this.zip && this.template.querySelector('[data-id="zip"]') && this.template.querySelector('[data-id="zip"]').validity.valid);
    }
}