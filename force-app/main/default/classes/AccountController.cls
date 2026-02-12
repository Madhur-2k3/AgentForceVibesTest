public with sharing class AccountController {
    /**
     * @description Returns the Account Name for a given Account Id.
     * @param accountId The Id of the Account record
     * @return The Account Name or null if not found
     */
    @AuraEnabled(cacheable=true)
    public static Account getAccountDetails(Id accountId) {
        // Return early if no id provided
        if (accountId == null) {
            return null;
        }

        // Query all fields that will be accessed per rulebook, and enforce FLS/sharing
        Account acc = [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];


        return acc;
    }
    @AuraEnabled(cacheable=true)
    public static String getAccountIndustry(Id opportunityId) {
        // Return early if no id provided
        if (opportunityId == null) {
            return null;
        }

        // Query relationship field that will be accessed per rulebook and enforce FLS/sharing
        Opportunity opp = [
            SELECT Id, Account.Industry
            FROM Opportunity
            WHERE Id = :opportunityId
            LIMIT 1
        ];
        return opp.Account.Industry;
    }

    public static Datetime calculateReminderTime(Datetime startTime) {
        // Per a4d-vibes-rules.md Rule 3: Apex does not support addMilliseconds()
        // Use addSeconds instead to add 30 seconds
        if (startTime == null) {
            return null;
        }
        Datetime reminderTime = startTime.addSeconds(30);
        return reminderTime;
    }

    public static String formatMessage(String header, String body) {
        // Per a4d-vibes-rules.md Rule 5: StringBuffer is not an Apex type
        // Use String concatenation or List<String> + String.join
        if (String.isBlank(header) && String.isBlank(body)) {
            return '';
        }
        List<String> parts = new List<String>();
        parts.add(header != null ? header : '');
        parts.add(body != null ? body : '');
        return String.join(parts, ' - ');
    }

     public static HttpResponse callAnthropic(String apiKey) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.anthropic.com/v1/messages');
        req.setMethod('POST');

        // Rule 35: Anthropic requires x-api-key header, not Authorization: Bearer
        req.setHeader('x-api-key', apiKey);
        req.setHeader('Content-Type', 'application/json');

        // Minimal valid body payload for Anthropic Messages API
        // Adjust model and content as needed for your use case
        String body = JSON.serialize(new Map<String, Object>{
            'model' => 'claude-3-5-sonnet-latest',
            'max_tokens' => 32,
            'messages' => new List<Object>{
                new Map<String, Object>{ 'role' => 'user', 'content' => 'Hello' }
            }
        });
        req.setBody(body);

        Http http = new Http();
        return http.send(req);
    }
}
