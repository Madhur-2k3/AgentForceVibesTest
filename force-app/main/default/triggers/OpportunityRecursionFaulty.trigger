trigger OpportunityRecursionFaulty on Opportunity (after update) {
    OpportunityRecursionFaultyHandler.handle(Trigger.new);
}
