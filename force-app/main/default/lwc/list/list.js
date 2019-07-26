import { LightningElement, track } from 'lwc';
import { bikes } from 'c/data';

export default class List extends LightningElement {
    bikes = bikes;

    @track filterBikes;

    constructor() {
        super();
        this.filterBikes = bikes;
    }

    handleTileClick(evt) {
        // This component wants to emit a productselected event to its parent
        const event = new CustomEvent('productselected', {
            detail: evt.detail
        });
        // Fire the event from c-list
        this.dispatchEvent(event);
    }

    filterSearchItems(event) {
        this.filterBikes = this.bikes.filter((bike) =>
      bike.fields.Name.value.toLocaleLowerCase().indexOf(event.detail.value) !== -1);
      console.log(JSON.stringify(this.filterBikes));
    }
}