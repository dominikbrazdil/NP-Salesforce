trigger DarTrigger on Dar__c (after insert) {

    DarTriggerHandler.addDonorsToCampaigns(Trigger.New);
    DarTriggerHandler.markRecurrentDonors(Trigger.New);
}