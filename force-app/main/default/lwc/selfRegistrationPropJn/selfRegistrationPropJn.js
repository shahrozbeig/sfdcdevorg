/* eslint-disable no-console */
import { LightningElement, track } from 'lwc';

export default class SelfRegistrationPropJn extends LightningElement {
    @track firstName;
    @track lasttName;
    @track email;
    @track phone;
    @track street;
    @track city;
    @track state;
    @track postalcode;
    @track country;
    @track type;

    firstNameHandler(event) {
        this.firstName = event.target.value;
    }
    lastNameHandler(event) {
        this.lasttName = event.target.value;
    }
    emailHandler(event) {
        this.email = event.target.value;
    }
    phoneHandler(event) {
        this.phone = event.target.value;
    }
    streetHandler(event) {
        this.street = event.target.value;
    }
    cityHandler(event) {
        this.city = event.target.value;
    }
    stateHandler(event) {
        this.state = event.target.value;
    }
    countryHandler(event) {
        this.country = event.target.value;
    }
    postalHandler(event) {
        this.postalcode = event.target.value;
    }
    typeHandler(event) {
        this.type = event.target.value;
    }
    
    
     
}