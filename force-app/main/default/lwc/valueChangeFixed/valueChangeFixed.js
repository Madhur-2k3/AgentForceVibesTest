import { LightningElement, api } from 'lwc';

export default class ValueChangeFixed extends LightningElement {
    @api value = '';

    handleInput(event) {
        this.value = event.target.value;
        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: { value: this.value }
        }));
    }
}
