public class DarTriggerHandler {
    
    /**
     * Adds contact to campaign to which the new donation was donated
     */
    public static void addDonorsToDonationCampaigns(List<Dar__c> dary) {
        Set<CampaignMember> membersToAdd = new Set<CampaignMember>();

        Map<Id, Map<Id, Id>> contactToCampaigns = CampaignMemberHandler.getContactIdsToCampaignsIdsToMemberIdMap(Utils.mapToId(dary, Dar__c.Darce__c));

        for (Dar__c dar: dary) {
            if (!CampaignMemberHandler.isContactInCampaign(dar.Darce__c, dar.Kampan__c, contactToCampaigns)) {
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


    /**
     * Creates opportunities from donors meeting predefined donation criteria
     */
    @future // so Roll-up fields are already updated
    public static void createOpportunitiesFromRemarkableDonors(List<Id> donorIds, Id jobID) {
        Logger.init(jobID);

        Integer largeDonorsLimit = (Integer)Apex_config__c.getInstance().Large_donor_amount_of_donations_limit__c;
        
        List<Opportunity> oppsToAdd = new List<Opportunity>();

        for (Contact c: [SELECT Id, Email, FirstName, LastName, AccountId, Dary_suma__c, Celkovy_pocet_daru__c, (SELECT Id FROM Prilezitosti__r) FROM Contact WHERE Id IN :donorIds]) {
            if ((c.Dary_suma__c >= largeDonorsLimit)
                & c.Prilezitosti__r.isEmpty()) {
                oppsToAdd.add(new Opportunity(
                    Name = c.FirstName + ' ' + c.LastName,
                    Kontaktniosoba__c = c.Id,
                    AccountId = c.AccountId,
                    CloseDate = Date.today().addYears(1),
                    StageName = 'Příležitost'
                ));
            }
        }

        DatabaseManager.insertListPartialEnabled(oppsToAdd);
        Logger.closeAndStore();
    }
}
