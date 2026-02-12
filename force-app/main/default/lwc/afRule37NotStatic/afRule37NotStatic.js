import { LightningElement } from 'lwc';
import greet from '@salesforce/apex/AFRule37_NotStatic.greet';

export default class AfRule37NotStatic extends LightningElement {
    connectedCallback() {
        greet()
            .then(result => console.log('NotStatic result:', result))
            .catch(error => console.error('NotStatic error:', error));
    }
}
