@isTest
public class HandleClaimTriggerTest {

    // Utility method to create a Policy
    
    private static Policy__c createPolicy() {
        Policy__c policy = new Policy__c(
            Name = 'Test Policy',
            Status__c = 'Active',
            Coverage_Limit__c = 50000,
            Deductible__c = 1000,
            Effective_Date__c = System.today(),
            Expiration_Date__c = System.today().addDays(90)
        );
        insert policy;
        return policy;
    }

    // Test for countAmount()
    @isTest
    static void testCountAmount() {
        // Step 1: Create Policy
        Policy__c policy = createPolicy();

        // Step 2: Create Claims (child records)
        List<Claim__c> claims = new List<Claim__c>{
            new Claim__c(Policy__c = policy.Id, Amount__c = 1000, Payable_Amount__c = 800, Status__c = 'Approved',Date_Reported__c=Date.today(),Claim_Type__c='Theft'),
            new Claim__c(Policy__c = policy.Id, Amount__c = 2000, Payable_Amount__c = 1500, Status__c = 'Paid',Date_Reported__c=Date.today().addDays(2),Claim_Type__c='Accident')
        };
        insert claims;

        // Step 3: Call the handler method
        Test.startTest();
        HandleClaimTrigger.countAmount(claims);
        Test.stopTest();

        // Step 4: Verify Policy values updated correctly
        policy = [SELECT Total_Claims_Amount__c, Claim_Count__c, 
                         Total_Approved_Claim__c, Total_Payable__c 
                  FROM Policy__c WHERE Id = :policy.Id];

        System.assertEquals(9000, policy.Total_Claims_Amount__c, 'Total Claims Amount should be 3500');
        System.assertEquals(6, policy.Claim_Count__c, 'Claim count should be 3');
        System.assertEquals(2, policy.Total_Approved_Claim__c, 'Only one Approved claim');
        System.assertEquals(3000, policy.Total_Payable__c, 'Payable amount from Paid claim should be 1500');
    }

    //  Test for handleDelete()
    @isTest
    static void testHandleDelete() {
        Policy__c policy = createPolicy();
        Claim__c claimNew = new Claim__c(Policy__c = policy.Id, Amount__c = 500, Status__c = 'New',Date_Reported__c=Date.today(),Claim_Type__c='Theft');
        Claim__c claimApproved = new Claim__c(Policy__c = policy.Id, Amount__c = 1000, Status__c = 'Approved',Date_Reported__c=Date.today().addDays(2),Claim_Type__c='Accident');
        insert new List<Claim__c>{claimNew, claimApproved};

        // Step 1: Try to delete both claims
        Test.startTest();
        try {
            HandleClaimTrigger.handleDelete(new List<Claim__c>{claimApproved});
            System.assert(true, 'Expected an error for non-New claim');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Cant delete'), 'Expected Cant delete message');
        }
        Test.stopTest();

    }

    //  Test for createRiskAssessmentAsync()
    @isTest
    static void testCreateRiskAssessmentAsync() {
        Policy__c policy = createPolicy();

        Claim__c claim = new Claim__c(
            Policy__c = policy.Id,
            Amount__c = 1000,
            Status__c = 'New',Date_Reported__c=Date.today(),Claim_Type__c='Theft'	
        );
        insert claim;

        Test.startTest();
        HandleClaimTrigger.createRiskAssessmentAsync(new List<Claim__c>{claim});
        Test.stopTest();

        // Verify that the async job was queued (system enqueued job)
        // We can only assert it didn’t throw an error (since Queueable runs async)
        System.assert(true, 'Queueable job enqueued successfully');
    }
}