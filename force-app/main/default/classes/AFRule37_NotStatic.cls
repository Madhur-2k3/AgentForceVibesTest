public class AFRule37_NotStatic {
    // Has @AuraEnabled but is NOT static - LWC expects public static
    @AuraEnabled
    public String greet() {
        return 'Hi';
    }
}
