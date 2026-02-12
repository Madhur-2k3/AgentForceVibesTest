trigger LeadRecursionFaulty on Lead (after update) {
    LeadRecursionFaultyHandler.handle(Trigger.new);
}
