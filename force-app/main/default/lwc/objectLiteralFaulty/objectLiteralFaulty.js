import { LightningElement, api } from 'lwc';

export default class ObjectLiteralFaulty extends LightningElement {
    @api token = 'demo-token';

    // Define properties referenced in the template instead of inline object literals
    headers = {
        Authorization: 'Bearer token'
    };

    config = {
        retry: 3,
        timeout: 1000
    };
}
