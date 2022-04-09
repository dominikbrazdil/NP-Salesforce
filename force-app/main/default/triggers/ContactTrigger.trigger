trigger ContactTrigger on Contact (after update) {
    ContactTriggerHandler.addDonorsToDonorCampaigns(Trigger.New, Trigger.Old);
}