public class PolicyRenewalReminderBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = System.today();
        Date upcoming = today.addDays(30);
        
        return Database.getQueryLocator([SELECT Id, Name, Expiration_Date__c, Status__c, Customer__c, Customer__r.Name, Customer__r.Owner.Email FROM Policy__c WHERE Status__c = 'Active' AND Expiration_Date__c >= :today AND Expiration_Date__c <= :upcoming]);
    }
    
    public void execute(Database.BatchableContext bc, List<Policy__c> policyList) {
        
        
        Set<Id> accountIds = new Set<Id>();
        for (Policy__c p : policyList) {
            if (p.Customer__c != null)
                accountIds.add(p.Customer__c);
        }
        
        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        for (Contact c : [SELECT Id, Name, Email, AccountId FROM Contact WHERE AccountId IN :accountIds AND Role__c = 'Decision Maker']) {
            
            accountToContactMap.put(c.AccountId, c);
            
        }
        
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        List<Notification__c> notificationsToInsert = new List<Notification__c>();
        
        for (Policy__c policy : policyList) {
            Contact decisionMaker = accountToContactMap.get(policy.Customer__c);
            
            String accountOwnerEmail = policy.Customer__r.Owner.Email;
            String accountOwnerName = policy.Customer__r.Name;
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{decisionMaker.Email});
            email.setCcAddresses(new List<String>{accountOwnerEmail});
            email.setSubject('Policy Renewal Reminder');
            email.setPlainTextBody(
                'Dear ' + accountOwnerName + ',\n\n' +
                'We hope you’re doing well. This is a friendly reminder that your policy "' + policy.Name +
                '" is due for renewal on ' + policy.Expiration_Date__c.format() + '.\n\n' +
                'To ensure uninterrupted coverage and continued protection, please complete your renewal before the due date.\n\n' +
                'Thanks,\nAdmin.');
            
            emailsToSend.add(email);
            
            Notification__c note = new Notification__c();
            note.Policy__c = policy.Id;
            note.Customer__c = policy.Customer__c;
            note.Contact__c = decisionMaker.Id;
            note.Type__c = 'Policy Lapsed	';
            note.SentDate__c = System.now();
            notificationsToInsert.add(note);
        }
        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend, false);
        }
        
        if (!notificationsToInsert.isEmpty()) {
            insert notificationsToInsert;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Policy Renewal Reminder Batch completed successfully.');
    }
}