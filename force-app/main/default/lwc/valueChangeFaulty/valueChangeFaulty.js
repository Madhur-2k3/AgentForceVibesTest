import { LightningElement, api } from 'lwc';

export default class ValueChangeFaulty extends LightningElement {
    @api value = '';

    handleInput(event) {
        const newValue = event.target.value;
        this.value = newValue;
        // Per .a4drules/a4d-vibes-rules.md Rule 41, dispatch valuechange so Agentforce receives updates
        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: { value: newValue }
        }));
    }
}
