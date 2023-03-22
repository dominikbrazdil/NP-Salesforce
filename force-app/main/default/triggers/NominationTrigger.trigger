trigger NominationTrigger on Nominace__c (after insert) {

    NominationTriggerHandler.addNominatingContactsToCampaigns(Trigger.New);

}