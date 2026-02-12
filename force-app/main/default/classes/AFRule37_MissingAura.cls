public class AFRule37_MissingAura {
    // Missing @AuraEnabled - LWC call will fail to find Apex action
    public static String greet() {
        return 'Hello';
    }
}
