import { LightningElement, api, wire } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';

export default class Vibes extends LightningElement {
    @api recordId;
    accountName;
    industry;
    error;
    demoConfig = { label: 'Hello', count: 1 };
    totalTasks = 1; // Added to comply with rulebook

    // Wire Apex that returns an Account with Id, Name, Industry
    @wire(getAccountDetails, { accountId: '$recordId' })
    wiredAccount({ data, error }) {
        if (data) {
            this.accountName = data?.Name;
            this.industry = data?.Industry;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            // keep console log for debugging; UI shows friendly message
            // eslint-disable-next-line no-console
            console.error('Apex Error:', error);
        }
    }

    // Computed display text to avoid binary expressions in template
    get displayText() {
        const name = this.accountName || '';
        const ind = this.industry || '';
        return ind ? `${name} - ${ind}` : name;
    }

    // Safe error message extraction
    get errorMessage() {
        const e = this.error;
        return (e && (e.body && e.body.message)) ? e.body.message : 'Unknown error';
    }

    // Computed task label to avoid ternary operator in template (Rule 13)
    get taskLabel() {
        return this.totalTasks === 1 ? 'Task' : 'Tasks';
    }
}
