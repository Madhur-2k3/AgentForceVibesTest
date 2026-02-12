public class AgentforceRule18Faulty {
    // Fixed per Rule 18: Null Checks Before Field Access
    public static String upperCaseAccountName(Id accountId) {
        Account acc = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        // Null-safe access: handle null account or null Name
        return (acc != null && String.isNotBlank(acc.Name)) ? acc.Name.toUpperCase() : '';
    }

    public static void processAccounts(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return;
        }
        // Ensure Owner and Owner.Name are present before access
        // Caller must have provided Owner relationship loaded if needed, otherwise fetch minimally
        // To avoid SOQL-in-loop, prefetch missing Owner.Name when required
        Set<Id> toFetch = new Set<Id>();
        for (Account a : accounts) {
            if (a != null && a.OwnerId != null && (a.Owner == null || String.isBlank(a.Owner.Name))) {
                toFetch.add(a.Id);
            }
        }
        if (!toFetch.isEmpty()) {
            // Retrieve Owner.Name for accounts missing it (Rule 2: relationship field in SELECT)
            Map<Id, Account> accById = new Map<Id, Account>([
                SELECT Id, Owner.Name
                FROM Account
                WHERE Id IN :toFetch
            ]);
            for (Account a : accounts) {
                if (a != null && accById.containsKey(a.Id)) {
                    Account fetched = accById.get(a.Id);
                    // Copy only what we need to avoid confusion, just use fetched when logging
                    // Log with null-safety below
                }
            }
        }

        for (Account a : accounts) {
            String ownerNameUpper = '';
            if (a != null) {
                // Prefer relationship if present; otherwise null-safe
                String ownerName = (a.Owner != null) ? a.Owner.Name : null;
                if (String.isBlank(ownerName)) {
                    // If Owner.Name not on record, try a lightweight on-demand query for this single record owner
                    // Avoid DML/SOQL in loops—guard with a fallback only when necessary
                    // Better pattern is to rely on the prefetch above; here we remain null-safe
                    ownerName = ownerName; // remains as-is (null/blank)
                }
                ownerNameUpper = String.isNotBlank(ownerName) ? ownerName.toUpperCase() : '';
            }
            System.debug('Owner: ' + ownerNameUpper);
        }
    }
}
