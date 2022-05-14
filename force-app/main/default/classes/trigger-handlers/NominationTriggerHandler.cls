public class NominationTriggerHandler {
    
    /**
     * Adds nominated contacts to campaigns of their nomination
     */
    public static void addNominatedContactsToCampaigns(List<Nominace__c> nominations) {
        Set<CampaignMember> membersToAdd = new Set<CampaignMember>();

        Map<Id, Map<Id, Id>> existingContactToCampaigns = CampaignMemberHandler.getContactIdsToCampaignsIdsToMemberIdMap(Utils.mapToId(nominations, Nominace__c.Nominovany__c));

        for (Nominace__c n: nominations) {
            if (n.Nominovany__c != null && (!CampaignMemberHandler.isContactInCampaign(n.Nominovany__c, n.Kampan__c, existingContactToCampaigns))) {
                membersToAdd.add(new CampaignMemberHandler()
                    .setCampaignId(n.Kampan__c)
                    .setContactId(n.Nominovany__c)
                    .build()
                );
            }
        }

        DatabaseManager.insertListPartialEnabled(new List<CampaignMember>(membersToAdd));
    }
}
