trigger DarTrigger on Dar__c (after insert) {

    DarTriggerHandler.addDonorsToDonationCampaigns(Trigger.New);
    DarTriggerHandler.markRecurrentDonors(Trigger.New);
    DarTriggerHandler.createOpportunitiesFromRemarkableDonors(Utils.mapToId(Trigger.New, Dar__c.Darce__c), Logger.getJobId());
}