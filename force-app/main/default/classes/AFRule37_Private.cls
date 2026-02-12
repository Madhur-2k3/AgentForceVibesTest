public class AFRule37_Private {
    // Annotated but private - not accessible to LWC
    @AuraEnabled
    private static String greet() {
        return 'Secret';
    }
}
