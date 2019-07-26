import { LightningElement, track} from 'lwc';

export default class OnboardingForm extends LightningElement {
    @track showAlert = 'Test';
    
    handleSelect(event){
        this.showAlert = event.detail.name;
    }
}