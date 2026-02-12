import { LightningElement } from 'lwc';

export default class TernaryFaulty extends LightningElement {
    count = 0;

    handleChange(event) {
        this.count = parseInt(event.target.value, 10) || 0;
    }

    // Move conditional logic from template to getter to avoid LWC1060
    get itemLabel() {
        return this.count === 1 ? 'item' : 'items';
    }
}
