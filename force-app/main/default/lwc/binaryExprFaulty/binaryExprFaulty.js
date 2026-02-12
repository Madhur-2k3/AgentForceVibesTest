import { LightningElement, track } from 'lwc';

export default class BinaryExprFaulty extends LightningElement {
    @track index = 0;

    // Rule 14 compliance: compute binary expression in JS, not in template
    get rowNumber() {
        return (this.index ?? 0) + 1;
    }

    handleIndexChange(event) {
        this.index = parseInt(event.target.value, 10) || 0;
    }
}
