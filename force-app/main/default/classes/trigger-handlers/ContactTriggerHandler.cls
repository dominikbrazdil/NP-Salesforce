public class ContactTriggerHandler {
    
    /**
     * Adds donors with changed donations to correct campaigns and removes them from not actual ones
     */
    public static void addDonorsToDonorCampaigns(List<Contact> updatedDonors, List<Contact> oldDonors) {
        
        
        Set<CampaignMember> membersToAdd = new Set<CampaignMember>();
        Set<CampaignMember> membersToRemove = new Set<CampaignMember>();

        Map<Id, Map<Id, Id>> contactToCampaigns = CampaignMemberHandler.getContactIdsToCampaignsIdsToMemberIdMap(Utils.mapToId(oldDonors, Contact.Id));

        for (Integer i = 0; i < updatedDonors.size(); i++) {
            Id donorId = oldDonors[i].Id;
            List<Id> updatedDonorCampaigns = ContactHandler.getRelevantDonorCampaignIds(updatedDonors[i]);
            List<Id> oldDonorCampaigns = ContactHandler.getRelevantDonorCampaignIds(oldDonors[i]);

            for (Id updatedCampaignId: updatedDonorCampaigns) {
                if (!oldDonorCampaigns.contains(updatedCampaignId) || !CampaignMemberHandler.isContactInCampaign(donorId, updatedCampaignId, contactToCampaigns)) {
                    membersToAdd.add(new CampaignMemberHandler()
                        .setCampaignId(updatedCampaignId)
                        .setContactId(donorId)
                        .build() 
                    );
                }
            }
 
            for (Id oldCampaignId: oldDonorCampaigns) {
                if (!updatedDonorCampaigns.contains(oldCampaignId) && CampaignMemberHandler.isContactInCampaign(donorId, oldCampaignId, contactToCampaigns)) {
                    membersToRemove.add(new CampaignMember(Id = contactToCampaigns.get(donorId).get(oldCampaignId)));
                }
            }
        }

        DatabaseManager.insertListPartialEnabled(new List<CampaignMember>(membersToAdd));
        DatabaseManager.deleteListPartialEnabled(new List<CampaignMember>(membersToRemove));
    }
}
