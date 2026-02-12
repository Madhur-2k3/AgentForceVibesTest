public with sharing class AgentforceRule38Faulty {

    public class AccountList {
        public String Name;
        public String Industry;
    }

    public class Input {
        @InvocableVariable
        public List<AccountList> accounts;
    }

    @InvocableMethod(label='Process Accounts (Faulty)')
    public static void process(List<Input> requests) {
        // Add basic implementation to avoid empty method
        if (requests == null) {
            return;
        }
        for (Input req : requests) {
            if (req.accounts != null) {
                for (AccountList acc : req.accounts) {
                    // Basic processing - in real scenario, this would do something useful
                    System.debug('Processing account: ' + acc.Name);
                }
            }
        }
    }
}
