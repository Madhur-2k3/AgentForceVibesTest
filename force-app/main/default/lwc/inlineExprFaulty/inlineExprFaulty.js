import { LightningElement, api } from 'lwc';

export default class InlineExprFaulty extends LightningElement {
    @api record;
    items = [];
    count = 0;

    connectedCallback() {
        this.items = ['a', 'b'];
        this.count = this.items.length;
    }

    // Computed properties to replace inline expressions (avoid LWC1083)
    get recordSummary() {
        const name = this.record?.Name || '';
        const industry = this.record?.Industry || '';
        // Safely join with hyphen only when values exist
        if (name && industry) {
            return `${name} - ${industry}`;
        }
        return name || industry || '';
    }

    get hasItems() {
        return Array.isArray(this.items) && this.items.length > 0;
    }

    get countLabel() {
        return this.count === 1 ? 'one' : 'many';
    }
}
