public class OpportunityRecursionFaultyHandler {
    // Rule 21: Recursive Trigger Prevention using static flag
    private static Boolean isExecuting = false;

    public static void handle(List<Opportunity> opps) {
        if (isExecuting) {
            return;
        }
        isExecuting = true;
        try {
            List<Opportunity> toUpdate = new List<Opportunity>();
            for (Opportunity o : opps) {
                if (o.StageName == 'Closed Won') {
                    // Update only fields that won't retrigger logic paths unnecessarily
                    Opportunity up = new Opportunity(
                        Id = o.Id,
                        Description = 'Marked processed at ' + Datetime.now().format()
                    );
                    toUpdate.add(up);
                }
            }
            if (!toUpdate.isEmpty()) {
                update toUpdate;
            }
        } finally {
            isExecuting = false;
        }
    }
}
