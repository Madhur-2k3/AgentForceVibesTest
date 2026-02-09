@isTest
private class PolicyTest {

    @isTest
    static void myUnitTest() {
        

        Policy__c policy = new Policy__c();
        policy.Total_Claims_Amount__c = 1000;
        policy.Name='Demo 2';
        policy.Status__c='Active';
        policy.Effective_Date__c=Date.today();
        policy.Expiration_Date__c=Date.today().addDays(10);
        policy.Claim_Count__c = 1;
        policy.Total_Approved_Claim__c = 1;
        policy.Total_Payable__c = 1000;
        insert policy;

        Claim__c claim = new Claim__c();
        claim.Amount__c = 1000;
        claim.Status__c = 'Approved';
        claim.Payable_Amount__c = 1000;
        claim.Date_Reported__c = Date.today();
        claim.Assessment_Status__c='Pending';
        claim.Claim_Type__c='Theft';
        claim.Policy__c=policy.Id;

        insert claim;

        policy = [SELECT Id,Total_Claims_Amount__c,Claim_Count__c,Total_Approved_Claim__c,Total_Payable__c FROM Policy__C WHERE Id = :policy.Id];

      
        

    }
}