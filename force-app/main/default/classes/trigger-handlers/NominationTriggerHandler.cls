public class NominationTriggerHandler {
    
    public static void addNominatedContactsToCampaigns(List<Nominace__c> nominations) {
        Set<CampaignMember> membersToAdd = new Set<CampaignMember>();

        Map<Id, List<Id>> existingContactToCampaigns = CampaignMemberHandler.getContactsCampaignsMap(Utils.mapToId(nominations, Nominace__c.Nominovany__c));

        for (Nominace__c n: nominations) {
            if (n.Nominovany__c != null &&
                (!existingContactToCampaigns.containsKey(n.Nominovany__c) || 
                !existingContactToCampaigns.get(n.Nominovany__c).contains(n.Kampan__c))) {
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
