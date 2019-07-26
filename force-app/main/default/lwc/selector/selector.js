import { LightningElement, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
// import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import slick from '@salesforce/resourceUrl/slick';


const fields = [NAME_FIELD];

export default class Selector extends LightningElement {
    @track selectedProductId;
    handleProductSelected(evt) {
        this.selectedProductId = evt.detail;
    }
    userId = Id;
    @wire(getRecord, { recordId: '$userId', fields })
    user;
    get name() {
        return getFieldValue(this.user.data, NAME_FIELD);
    }

    /* renderedCallback() {

        Promise.all([
            // loadScript(this, slick + '/slick-master/slick/slick.min.js'),
            loadStyle(this, slick + '/slick-master/slick/slick.css'),
        ])
            .then(() => {
                console.log('Files loaded.');
            })
            .catch(error => {
                console.log(slick + 'Not loaded');
            });
    } */
}