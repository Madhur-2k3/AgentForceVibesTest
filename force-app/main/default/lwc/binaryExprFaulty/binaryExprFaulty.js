import { LightningElement } from 'lwc';

export default class BinaryExprFaulty extends LightningElement {
    index = 0;

    handleIndexChange(event) {
        this.index = parseInt(event.target.value, 10) || 0;
    }

    // Getter to compute row number (avoid inline arithmetic in template)
    get rowNumber() {
        return this.index + 1;
    }
}
