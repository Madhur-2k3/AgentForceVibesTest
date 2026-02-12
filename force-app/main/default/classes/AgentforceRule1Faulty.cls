public with sharing class AgentforceRule1Faulty {
    /**
     * Returns the Account Name for a given Account Id.
     * Enforces FLS/sharing via WITH SECURITY_ENFORCED.
     * Returns null when not found or not accessible.
     */
    public static String getAccountName(Id accountId) {
        if (accountId == null) {
            return null;
        }
        List<Account> accts = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :accountId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        if (accts.isEmpty()) {
            return null;
        }
        return accts[0].Name;
    }

    /**
     * Returns a map of Contact Id to related Account Name (null if no account).
     * Avoids System.debug and uses defensive null checks.
     */
    public static Map<Id, String> getSampleContactAccountNames() {
        Map<Id, String> result = new Map<Id, String>();
        List<Contact> contacts = [
            SELECT Id, AccountId, Account.Name
            FROM Contact
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
        for (Contact c : contacts) {
            String acctName = (c.AccountId != null && c.Account != null) ? c.Account.Name : null;
            result.put(c.Id, acctName);
        }
        return result;
    }
}
