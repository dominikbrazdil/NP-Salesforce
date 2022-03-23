trigger ContactTrigger on Contact (after insert, after update) {
    
    ContactTriggerHandler.createOpportunitiesFromReamrkableDonors(Trigger.New);
}