public class DarTriggerHandler {
    
    /**
     * Adds contact to campaign to which the new donation was donated
     */
    public static void addDonorsToCampaigns(List<Dar__c> dary) {
        Set<CampaignMember> membersToAdd = new Set<CampaignMember>();

        Map<Id, List<Id>> contactToCampaigns = CampaignMemberHandler.getContactsCampaignsMap(Utils.mapToId(dary, Dar__c.Darce__c));

        for (Dar__c dar: dary) {
            if (!contactToCampaigns.containsKey(dar.Darce__c) || !contactToCampaigns.get(dar.Darce__c).contains(dar.Kampan__c)) {
                membersToAdd.add(new CampaignMemberHandler()
                    .setCampaignId(dar.Kampan__c)
                    .setContactId(dar.Darce__c)
                    .build()
                );
            }
        }

        DatabaseManager.insertListPartialEnabled(new List<CampaignMember>(membersToAdd));
    }


    /**
    * Marks contact as recurrent donor if the transactions was part of recurrent pledge
    */
    public static void markRecurrentDonors(List<Dar__c> dary) {
        Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();

        for (Dar__c dar: dary) {
            if (dar.Pravidelny_dar__c && !contactsToUpdate.containsKey(dar.darce__c)) {
                contactsToUpdate.put(dar.darce__c, new Contact(
                    Id = dar.darce__c,
                    Pravidelny_darce__c = true,
                    Prislibena_castka__c = dar.Darovana_castka__c
                ));
            }
        }

        DatabaseManager.updateListPartialEnabled(contactsToUpdate.values());
    }
}
