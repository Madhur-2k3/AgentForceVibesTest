public with sharing class AgentforceRule37Faulty {

    // Rule 37 compliance: Method must be @AuraEnabled and static for LWC to call
    @AuraEnabled(cacheable=true)
    public static String myMethod() {
        return 'Hello';
    }
}
