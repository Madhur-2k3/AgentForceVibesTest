public with sharing class AgentforceRule39Faulty {
    @JsonAccess(serializable='always' deserializable='always')
    public class AccountData {
        @AuraEnabled public String name;
        @AuraEnabled public String industry;
    }

    @InvocableMethod
    public static List<AccountData> getAccounts() {
        AccountData ad = new AccountData();
        ad.name = 'Acme';
        ad.industry = 'Manufacturing';
        return new List<AccountData>{ ad };
    }
}
