public class PolicyExpirationBatchClass implements Database.Batchable<sObject>,Database.Stateful {
    Integer count=0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select Id,Expiration_Date__c,Status__c from Policy__c where Status__c!='Lapsed' and Expiration_Date__c=today]);
    }
    public void execute(Database.BatchableContext bc,List<Policy__c> policyList){
        List<Policy__c> updatePolicyList = new List<Policy__c>();
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        for(policy__c policy:policyList){
            policy.Status__c='Lapsed';
            updatePolicyList.add(policy);
        }
        if(!updatePolicyList.isEmpty()){
            Database.SaveResult[] policiesUpdate = Database.update(updatePolicyList,false);
        
        for(Integer i=0;i<policiesUpdate.size();i++){
            if(!policiesUpdate[i].isSuccess()){
                for(Database.Error err : policiesUpdate[i].getErrors()){
                    errorLogs.add(new Error_Log__c(Errror_Message__c=err.getMessage()));
                }
            }
            else count++;
		}
        if(!errorLogs.isEmpty()){
            insert errorLogs;
        }
        }
        Reconciliation_Summary__c summary =new Reconciliation_Summary__c(Date__c=System.today(),Policies_Lapsed__c=count);
        insert summary;
        
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Total records executed: '+count);
    }
}