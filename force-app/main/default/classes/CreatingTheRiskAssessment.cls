public class CreatingTheRiskAssessment implements Queueable {
    
    public List<Claim__c> claimList;
    
    public CreatingTheRiskAssessment(List<Claim__c> claimList) {
        this.claimList = claimList;
    }
    
    public void execute(QueueableContext qc) {
        try {
            List<Risk_Assessment__c> riskToInsert = new List<Risk_Assessment__c>();
            List<Claim__c> claimsToUpdate = new List<Claim__c>();
            List<Error_Log__c> errorLogs = new List<Error_Log__c>();
            Set<Id> policyIds = new Set<Id>();
            Map<Id, Policy__c> policyMap = new Map<Id, Policy__c>();
            
            for (Claim__c c : claimList) {
                if (c.Policy__c != null) {
                    policyIds.add(c.Policy__c);
                }
            }
            
            for(Policy__c policyRec : [SELECT Id, Coverage_Limit__c, Effective_Date__c, 
                                       (SELECT Id FROM Claims__r WHERE Date_Reported__c = THIS_YEAR) 
                                       FROM Policy__c WHERE Id IN :policyIds]){
                                           policyMap.put(policyRec.Id, policyRec);
                                       }
            
            for (Claim__c c : claimList) {
                try {
                    Policy__c p = policyMap.get(c.Policy__c);
                    if (p == null) continue;
                    
                    Decimal totalCoverage = p.Coverage_Limit__c != null ? p.Coverage_Limit__c : 1;
                    Decimal amount = c.Amount__c != null ? c.Amount__c : 0;
                    Decimal w1 = Math.min(1, amount / totalCoverage);
                    
                    Decimal noOfClaimsThisYear = p.Claims__r != null ? p.Claims__r.size() : 0;
                    Decimal frequency = Math.min(1, noOfClaimsThisYear * 0.2);
                    
                    Date claimDate = c.Date_Reported__c;
                    Date policyDate = p.Effective_Date__c;
                    Integer days = (claimDate != null && policyDate != null) ? claimDate.daysBetween(policyDate) : 0;
                    
                    Decimal policyAge;
                    if (days < 30) {
                        policyAge = 0.5;
                    }
                    else if (days <= 180){
                        policyAge = 0.3;
                    }
                    else {
                        policyAge = 0;
                    }
                    
                    Decimal w4 = 0;
                    if (c.Claim_Type__c == 'Theft'){
                        w4 = 0.5;
                    }
                    else if (c.Claim_Type__c == 'Accident') {
                        w4 = 0.3;
                    }
                    else if (c.Claim_Type__c == 'Act of God'){
                        w4 = 0.2;
                    }
                    
                    Decimal totalScore = Math.min(1, w1 + frequency + policyAge + w4);
                    
                    Risk_Assessment__c risk = new Risk_Assessment__c(Claim__c = c.Id, Score__c = totalScore);
                    
                    Claim__c claimToUpdate = new Claim__c(Id = c.Id);
                    
                    if (totalScore <= 0.3) {
                        risk.Recommendation__c = 'Approve';
                        claimToUpdate.AutoApproved__c = true;
                        claimToUpdate.Status__c = 'Under Review';
                    } else if (totalScore <= 0.95) {
                        risk.Recommendation__c = 'Manual_Review';
                        claimToUpdate.Status__c = 'Under Review';
                    } else {
                        risk.Recommendation__c = 'Reject';
                        claimToUpdate.Status__c = 'Rejected';
                    }
                    
                    claimToUpdate.Assessment_Status__c = 'Completed';
                    riskToInsert.add(risk);
                    claimsToUpdate.add(claimToUpdate);
                } 
                catch (Exception ex) {
                    errorLogs.add(new Error_Log__c(Errror_Message__c = ex.getMessage()));
                }
            }
            
            
            if (!riskToInsert.isEmpty()) {
                Database.SaveResult[] riskResults = Database.insert(riskToInsert, false);
                for (Integer i = 0; i < riskResults.size(); i++) {
                    if (!riskResults[i].isSuccess()) {
                        for (Database.Error err : riskResults[i].getErrors()) {
                            errorLogs.add(new Error_Log__c(Errror_Message__c = err.getMessage()));
                            claimsToUpdate[i].Assessment_Status__c = 'Failed';
                        }
                    }
                }
            }
            
            if (!claimsToUpdate.isEmpty()) {
                Database.SaveResult[] claimResults = Database.update(claimsToUpdate, false);
                for (Database.SaveResult res : claimResults) {
                    if (!res.isSuccess()) {
                        for (Database.Error err : res.getErrors()) {
                            errorLogs.add(new Error_Log__c(Errror_Message__c = err.getMessage()));
                        }
                    }
                }
            }
            
            if (!errorLogs.isEmpty()) {
                insert errorLogs;
            }
            
        } catch (Exception e) {
            insert new Error_Log__c(Errror_Message__c = 'Fatal Error: ' + e.getMessage());
        }
    }
}