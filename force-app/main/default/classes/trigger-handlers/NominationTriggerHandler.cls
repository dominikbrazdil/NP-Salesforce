public class NominationTriggerHandler {
    
    /**
     * Adds nominating contacts to campaigns of their nomination
     */
    public static void addNominatingContactsToCampaigns(List<Nominace__c> nominations) {
        Set<CampaignMember> membersToAdd = new Set<CampaignMember>();

        Map<Id, Map<Id, Id>> existingContactToCampaigns = CampaignMemberHandler.getContactIdsToCampaignsIdsToMemberIdMap(Utils.mapToId(nominations, Nominace__c.Nominujici__c));

        for (Nominace__c n: nominations) {
            if (!CampaignMemberHandler.isContactInCampaign(n.Nominujici__c, n.Kampan__c, existingContactToCampaigns)) {
                membersToAdd.add(new CampaignMemberHandler()
                    .setCampaignId(n.Kampan__c)
                    .setContactId(n.Nominujici__c)
                    .build()
                );
            }
        }

        DatabaseManager.insertListPartialEnabled(new List<CampaignMember>(membersToAdd));
    }
}
