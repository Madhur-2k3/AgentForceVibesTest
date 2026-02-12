import { LightningElement, api, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactService.getContacts';

export default class DecoratorFaulty2 extends LightningElement {
    @api recordId; 

    @track contacts; 

    @wire(getContacts, { accountId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) this.contacts = data;
        else this.contacts = [];
    }
}
