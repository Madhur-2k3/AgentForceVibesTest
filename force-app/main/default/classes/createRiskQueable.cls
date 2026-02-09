public class createRiskQueable implements Queueable {
    private Set<Id> claimIds;
    public createRiskQueable(Set<Id> claimIds){
        this.claimIds = claimIds;
    }
    public void execute(QueueableContext context){
        
        List<Claim__c> claimList = new List<Claim__c>([select Id,Policy__c,Amount__c,Status__c,Date_Reported__c,Assessment_Status__c,Claim_Type__c from Claim__c where id in :claimIds]);
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        Decimal w1 =0;
        for(Claim__c claim:claimList){
            w1+=Math.min(1,(claim.Amount__c/claim.Policy__r.Coverage_Limit__c));
        }
        
        Map<Id,Integer> ownerMap = new Map<Id,Integer>();
        for(Claim__c claim:claimList){
            if(ownerMap.containsKey(claim.Policy__r.OwnerId)){
                ownerMap.put(claim.Policy__r.OwnerId,ownerMap.get(claim.Policy__r.OwnerId)+1);
            }else{
                ownerMap.put(claim.OwnerId,1);
            }
        }

        Decimal w2 =0;
        for(Claim__c claim:claimList){
            Integer pastClaims = ownerMap.get(claim.Policy__r.OwnerId);
            w2=Math.min(1,(pastClaims*(0.2)));
        }
        Decimal w3 =0;
        //if claim date within 30 days of policy start date
        for(Claim__c claim:claimList){
            if(claim.Date_Reported__c.daysBetween(claim.Policy__r.Effective_Date__c)<=30){
                w3+=0.5;
            }
            //within 30 to 180 days
            else if(claim.Date_Reported__c.daysBetween(claim.Policy__r.Effective_Date__c)<=180){
                w3+=0.3;
            }
            else{
                w3=0;
            }
        }
        Decimal w4;
        for(Claim__c claim:claimList){
            if(claim.Claim_Type__c=='Theft'){
                w4=0.5;
            }
            else if(claim.Claim_Type__c=='Accident'){
                w4=0.3;
            }
            else if(claim.Claim_Type__c=='Act of God'){
                w4=0.2;
            }
        }

        Decimal riskScore = w1+w2+w3+w4;
        if(riskScore>1) riskScore=1;
        List<Risk_Assessment__c> riskList = new List<Risk_Assessment__c>();
        //create risk record based on risk score
        for(Claim__c claim:claimList){
            Risk_Assessment__c risk = new Risk_Assessment__c();
            risk.Claim__c = claim.Id;
            if(riskScore<=0.3){
                risk.Recommendation__c='Approve';
            }
            else if(riskScore>0.3 && riskScore<=0.95){
                risk.Recommendation__c='Manual Review';
            }
            else{
                risk.Recommendation__c='Reject';
            }
            riskList.add(risk);

        }
        insert riskList;

        //if rec is approve then set auto approve is true
        for(Claim__c claim:claimList){
            if(claim.Assessment_Status__c=='Approve'){
                claim.AutoApproved__c=true;
                claim.Status__c='Under Review';
            }
            else if(claim.Assessment_Status__c=='Manual Review'){
                claim.Status__c='Under Review';
            }
            else{
                claim.Status__c='Rejected';
            }
        }
        update claimList;
        

    }

}