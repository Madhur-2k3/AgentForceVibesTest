public class HandleClaimTrigger {
    public static void countAmount(List<Claim__C> claimList){
        Set<Id> policyIds = new Set<Id>();
        
        for(Claim__C claim : claimList){
            policyIds.add(claim.Policy__c);
        }

        Map<Id,Policy__C> policyMap = new Map<Id,Policy__C>([SELECT Id,Total_Claims_Amount__c,Claim_Count__c,Total_Approved_Claim__c,Total_Payable__c FROM Policy__C WHERE Id IN :policyIds]);

        for(Claim__C claim : claimList){
            if(claim == null || claim.Policy__c == null) continue;
            Policy__C policy = policyMap.get(claim.Policy__c);
            if(policy == null) continue;

            if(policy.Total_Claims_Amount__c == null) policy.Total_Claims_Amount__c = 0;
            if(policy.Total_Payable__c == null) policy.Total_Payable__c = 0;
            if(policy.Claim_Count__c == null) policy.Claim_Count__c = 0;
            if(policy.Total_Approved_Claim__c == null) policy.Total_Approved_Claim__c = 0;

            if(claim.Amount__c != null){
                policy.Total_Claims_Amount__c += claim.Amount__c;
            }

            policy.Claim_Count__c += 1;

            if('Approved'.equalsIgnoreCase(claim.Status__c)){
                policy.Total_Approved_Claim__c += 1;
            }

            if('Paid'.equalsIgnoreCase(claim.Status__c) && claim.Payable_Amount__c != null){
                policy.Total_Payable__c += claim.Payable_Amount__c;
            }

            policyMap.put(policy.Id, policy);
        }
        update policyMap.values();
        
    }
    
    public static void handleDelete(List<Claim__c> oldClaimList){
        for(Claim__c claim:oldClaimList){
            if(claim.Status__c!='New'){
                claim.addError('Cant delete !');
			}
		}
    }
    
    public static void createRiskAssessmentAsync(List<Claim__c> newClaimList){
        if(!newClaimList.isEmpty()){
            System.enqueueJob(new CreatingTheRiskAssessment(newClaimList));
        }
    }
}