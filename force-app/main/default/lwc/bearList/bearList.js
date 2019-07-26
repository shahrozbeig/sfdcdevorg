import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import ursusResources from '@salesforce/resourceUrl/ursus_park';
/** BearController.getAllBears() Apex method */
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';
import getAllBears from '@salesforce/apex/BearController.getAllBears';
import searchBears from '@salesforce/apex/BearController.searchBears';

export default class BearList extends NavigationMixin(LightningElement) {
	// @track bears;
    // @track error;
    @track hasResults;
    @track searchTerm = '';
    @wire( getAllBears ) bears;
    @track bears;
    @wire(CurrentPageReference) pageRef;
    @wire(searchBears, {searchTerm: '$searchTerm'})
    loadBears(result) {
      this.bears = result;
      if (result.data) {
        fireEvent(this.pageRef, 'bearListUpdate', result.data);
      }
    }

    /* appResources = {
		bearSilhouette: ursusResources +'/img/standing-bear-silhouette.png',
    }; */
    
    handleSearchTermChange(event){
        this.searchTerm = event.target.value;
    }

    get hasResults() {
        return (this.bears.data.length > 0);
    }

    connectedCallback() {
      // this.loadBears();
      loadStyle(this, ursusResources + '/style.css');
    }

    handleBearView(event) {
      // Get bear record id from bearview event
      const bearId = event.detail;
      // Navigate to bear record page
      this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
          recordId: bearId,
          objectApiName: 'Bear__c',
          actionName: 'view',
        },
      });
    }


    /* loadBears() {
		getAllBears()
			.then(result => {
				this.bears = result;
			})
			.catch(error => {
				this.error = error;
			});
    } */
}