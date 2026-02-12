public with sharing class LeadRecursionFaultyHandler {
    // Static flag to prevent recursion in triggers
    private static Boolean isExecuting = false;

    public static void handle(List<Lead> leads) {
        // Prevent recursion
        if (isExecuting) {
            return;
        }
        isExecuting = true;
        try {
            List<Lead> toUpdate = new List<Lead>();
            for (Lead l : leads) {
                if (l.Status == 'Working - Contacted') {
                    Lead up = new Lead(Id = l.Id, Description = 'Processed at ' + Datetime.now().format());
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
