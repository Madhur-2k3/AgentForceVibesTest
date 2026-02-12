import { LightningElement } from 'lwc';
import greet from '@salesforce/apex/AFRule37_MissingAura.greet';

export default class AfRule37MissingAura extends LightningElement {
    connectedCallback() {
        greet()
            .then(result => console.log('MissingAura result:', result))
            .catch(error => console.error('MissingAura error:', error));
    }
}
