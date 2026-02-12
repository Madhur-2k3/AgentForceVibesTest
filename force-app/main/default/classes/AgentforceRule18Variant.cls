public with sharing class AgentforceRule18Variant {
    /**
     * Returns the email address in uppercase for a given contact ID.
     * Uses WITH SECURITY_ENFORCED and handles null/missing emails gracefully.
     */
    public static String getUpperEmail(Id contactId) {
        if (contactId == null) {
            return null;
        }
        List<Contact> contacts = [
            SELECT Id, Email
            FROM Contact
            WHERE Id = :contactId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        if (contacts.isEmpty() || contacts[0].Email == null) {
            return null;
        }
        return contacts[0].Email.toUpperCase();
    }

    /**
     * Prints contact names and their account names to the debug log.
     * Uses WITH SECURITY_ENFORCED and safely handles missing accounts.
     */
    public static void printContactAccountNames() {
        List<Contact> contacts = [
            SELECT Id, Name, AccountId, Account.Name
            FROM Contact
            WITH SECURITY_ENFORCED
            LIMIT 50
        ];
        for (Contact c : contacts) {
            String accountName = (c.AccountId != null && c.Account != null) ? c.Account.Name : 'No Account';
            System.debug('Contact ' + c.Name + ' Account: ' + accountName);
        }
    }

    /**
     * Normalizes phone numbers by removing all non-digit characters.
     * Handles null phones gracefully.
     */
    public static List<String> normalizePhones(List<Contact> contacts) {
        List<String> results = new List<String>();
        for (Contact c : contacts) {
            String phone = c.Phone;
            if (phone != null) {
                results.add(phone.replaceAll('[^0-9]', ''));
            } else {
                results.add('');
            }
        }
        return results;
    }
}
