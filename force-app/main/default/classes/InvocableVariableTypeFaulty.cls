public with sharing class InvocableVariableTypeFaulty {
    public class InputWrapper {
        @InvocableVariable(required=true)
        public List<Account> accounts;
    }

    // Optional: example invocable method signature if needed by Flow
    // @InvocableMethod(label='Process Accounts' description='Processes provided Accounts')
    // public static void process(List<InputWrapper> requests) {
    //     // Implement logic here, bulkified and with USER_MODE DML if needed
    // }
}
