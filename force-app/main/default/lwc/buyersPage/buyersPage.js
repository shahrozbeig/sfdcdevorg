import { LightningElement, wire, track } from 'lwc';
import getAllProperties from '@salesforce/apex/PropertyJunctionHandler.getAllProperties';

export default class BuyersPage extends LightningElement {
    @track allProperties;
    
    @wire( getAllProperties ) allProperties;

    /* loadProperties({ error, data }) {
		if (error) {
			// TODO: handle error
		} else if (data) {
            // Get Bear data
            console.log('data: ' + JSON.stringify(data));
			this.allProperties = data;
		}
	} */

    connectedCallback() {
        console.log('All props: ' + JSON.stringify(this.allProperties));
    }
}