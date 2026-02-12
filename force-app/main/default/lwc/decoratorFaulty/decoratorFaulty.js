import { LightningElement, api, track } from 'lwc';

export default class DecoratorFaulty extends LightningElement {
    @api value;

    @track items = [];

    connectedCallback() {
        this.items = ['one', 'two'];
    }
}
