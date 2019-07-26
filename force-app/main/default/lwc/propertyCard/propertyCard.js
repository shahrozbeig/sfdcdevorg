/* eslint-disable no-console */
import { LightningElement, api } from 'lwc';

export default class PropertyCard extends LightningElement {
    @api property;
    
    connectedCallback() {
        console.log('1  props: ' + JSON.stringify(this.property));
        // console.log('2 props: ' + JSON.stringify(this.property.ContentDocumentLinks[0].ContentDocumentId));
        // console.log('All props: ' + JSON.stringify(this.property.ContentDocumentLinks.ContentDocumentId));
    }
    // @track imageUrl = "/servlet/servlet.FileDownload?file=" + this.documentLink.ContentDocumentId;
}