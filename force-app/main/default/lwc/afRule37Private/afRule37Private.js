import { LightningElement } from 'lwc';
import greet from '@salesforce/apex/AFRule37_Private.greet';

export default class AfRule37Private extends LightningElement {
    connectedCallback() {
        greet()
            .then(result => console.log('Private result:', result))
            .catch(error => console.error('Private error:', error));
    }
}
