public class RenewalLogic {

    public class flowinputs{
        @InvocableVariable(label='policy renewal')
    	public Date newExpirationDates;
        @InvocableVariable(label='policy renewal')
        public integer premium;
        @InvocableVariable(label='Policy renewal')
    	public list<Policy__c> policiesList;
    }
   
   	
    @InvocableMethod(label='policy renewal' description='Update the lapsed policies with new expiration date and premium')
    Public static void renewLapsedPolices(List<flowinputs> flowinput){
        date expirationdate=flowinput[0].newExpirationDates;
        decimal premiums=(decimal)flowinput[0].premium;
        set<Id>PolicyIds=new Set<Id>();
       for(Policy__c policy: flowinput[0].policiesList){
           PolicyIds.add(policy.Id);
        	
       }
        List<Policy__c>policiestoupdate=new List<Policy__c>();
        Map<Id,Policy__c> policyMap=new Map<Id,Policy__c>([select Id,Premium__c,Expiration_Date__c from Policy__c where Id in:PolicyIds]);
        for(Id policyid:PolicyIds){
          Policy__c policy=new Policy__c(Id=policyid,Expiration_Date__c=expirationdate);
          decimal oldpremium=(Decimal)policyMap.get(policyid).Premium__c;
            if(premiums<0){
                policy.Premium__c=(decimal)oldpremium-(decimal)premiums;
                
            }
            else{
                policy.Premium__c=(Decimal)oldpremium+(decimal)premiums;
            }
            policiestoupdate.add(policy);
        }
        List<Error_Log__c> errorlog=new List<Error_Log__c>();
        Update policiestoupdate;
        try{
            Update policiestoupdate;
           }
        catch(Exception e){
            Error_Log__c err=new Error_Log__c(Errror_Message__c=e.getMessage(),Source__c='PolicyRenewal.renewLapsedPolices',Name=e.getTypeName());
            errorlog.add(err);
        }
        insert errorlog;   
	}



}