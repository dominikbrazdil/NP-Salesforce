public without sharing class AdapterraLoader {

    private static final Integer PROGRAM_ID = 1;

    private static AdapterraFetcher fetcher = new AdapterraFetcher();
    
    
    public static void loadNominations() {
        Logger.log('Importing nominations from Adapterra Awards');
        
        List<Nomination> nominations = fetcher.getNominations();
        
        Logger.log(nominations.size() + ' Nominations to be inserted: ' + nominations);

        importNominations(nominations);
    }

    @TestVisible
    private static void importNominations(List<Nomination> nominations) {
        Importer.insertNonExistingContactsWithAccounts(mapToAccounts(nominations), mapToContacts(nominations));
        Importer.insertNominations(mapToNominace(nominations));
    }

    private static List<Account> mapToAccounts(List<Nomination> nominations) {
        List<Account> acs = new List<Account>();

        for (Nomination n: nominations) {
            acs.add(n.createNominatingAccount());
            if (n.contact.contaktPerson.email != n.nominating.email) {
                acs.add(n.createNominatedAccount());
            }
        }
        return acs;
    }

    private static List<Contact> mapToContacts(List<Nomination> nominations) {
        List<Contact> contats = new List<Contact>();

        for (Nomination n: nominations) {
            contats.add(n.createNominatingContact());
            if (n.contact.contaktPerson.email != n.nominating.email) {
                contats.add(n.createNominatedContact());
            }
        }
        return contats;
    }

    private static List<Nominace__c> mapToNominace(List<Nomination> nominations) {
        List<Nominace__c> noms = new List<Nominace__c>();
        Campaign campaign = CampaignHandler.getLatestCampaignFromProgram(PROGRAM_ID);
        Id campaignId;

        if (campaign == null) {
            Logger.log(LoggingLevel.ERROR, 'No campaign was found for Program with ID: ' + PROGRAM_ID);
        } else {
            campaignId = campaign.Id;
        }

        for (Nomination n: nominations) {
            Nominace__c nomination = n.createNomination();
            nomination.Kampan__c = campaignId;
            noms.add(nomination);
        }
        return noms;
    }
}
