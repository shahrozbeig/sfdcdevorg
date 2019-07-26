/* eslint-disable no-console */
import { LightningElement, track } from 'lwc';

export default class BuyerSearch extends LightningElement {
    @track bedroomValue = [];
    @track constructionValue = [];
    @track typeValue = 'all';
    @track subTypeValue = 'all';
    @track renderSecondRow = false;
    // allProperties = allProperties;
    @track filteredProperties;

    /* constructor() {
        super();
        this.filteredProperties = allProperties;
    } */

    get renderSecondRow() {
        return (this.type !== 'all' && this.subType !== 'all');
    }

    get bedroomOptions() {
        return [
            { label: "1 BHK", value: "1bhk" },
            { label: "2 BHK", value: "2bhk" },
            { label: "3 BHK", value: "3bhk" }
        ];
    }

    get propertyTypeOptions() {
        return [
            { label: "All", value: "all" },
            { label: "Residential", value: "residential" },
            { label: "Commercial", value: "commercial" }
        ];
    }

    get propertySubTypeOptions() {
        return [
            { label: "All", value: "all" },
            { label: "Buy", value: "buy" },
            { label: "Rent", value: "rent" }
        ];
    }

    get constructionOptions() {
        return [
            { label: "Under Construction", value: "underconstruction" },
            { label: "Ready To Move", value: "readytomove" }
        ];
    }

    get selectedConstructions() {
        return this.constructionValue.join(',');
    }

    get selectedBedrooms() {
        return this.bedroomValue.join(',');
    }

    get typeValue() {
        return this.typeValue;
    }

    get subTypeValue() {
        return this.subTypeValue;
    }

    filterSearchItems(event) {
        console.log('Keyword: ' + event.target.value);
        // this.filteredProperties = this.allProperties.filter((prop) => 
        //     prop.fields.name.value.toLocaleLowerCase().indexOf(event.detail.value) !== -1);
    }

    typeChangeHandler(event) {
        console.log('Type: ' + event.detail.value);
        this.typeValue = event.detail.value;
        this.renderSecondRow = this.typeValue !== 'all' && this.subTypeValue !== 'all';
        console.log('renderSecondRow(): ' + this.renderSecondRow);
    }

    subTypeChangeHandler(event) {
        this.subTypeValue = event.detail.value;
        console.log('Sub Type: ' + event.detail.value);
        this.renderSecondRow = this.typeValue !== 'all' && this.subTypeValue !== 'all';
        console.log('renderSecondRow(): ' + this.renderSecondRow);
    }

    handleBedroomChange(event) {
        this.bedroomValue = event.detail.value;
    }

    handleConstructionChange(event) {
        this.constructionValue = event.detail.value;
    }
}