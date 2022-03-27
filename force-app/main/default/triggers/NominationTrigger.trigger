trigger NominationTrigger on Nominace__c (after insert) {

    NominationTriggerHandler.addNominatedContactsToCampaigns(Trigger.New);

}