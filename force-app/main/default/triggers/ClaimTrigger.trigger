trigger ClaimTrigger on Claim__c (after insert, after update, before delete) {
    if(trigger.isBefore){
        if(trigger.isDelete){
            HandleClaimTrigger.handleDelete(trigger.old);
        }
    }
    
    if(trigger.isAfter){
        if((trigger.isInsert || trigger.isUpdate)){
            HandleClaimTrigger.countAmount(trigger.new);
        }
        if(trigger.isInsert){
            HandleClaimTrigger.createRiskAssessmentAsync(trigger.new);
        }
    }   
}