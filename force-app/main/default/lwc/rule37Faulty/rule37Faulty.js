import { LightningElement } from 'lwc';
import myMethod from '@salesforce/apex/AgentforceRule37Faulty.myMethod';

export default class Rule37Faulty extends LightningElement {
    connectedCallback() {
        myMethod()
            .then((result) => {
                // use result
                // eslint-disable-next-line no-console
                console.log(result);
            })
            .catch((error) => {
                // eslint-disable-next-line no-console
                console.error(error);
            });
    }
}
