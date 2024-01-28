/**
 * Class preprocessing lists of SObjects before importing them
 */
public class Importer {
    
    /**
     * Inserts only contacts not already present in database and maps account to each one of them
     */
    public static void insertNonExistingContactsWithAccounts(List<Account> accounts, List<Contact> contacts) {

        if (accounts.size() != contacts.size()) {
            Logger.log(LoggingLevel.ERROR, 'Accounts and contacts size is not the same.');
            return;
        }

        Map<String, Account> emailToAccount = new Map<String,Account>();
        Map<String, Contact> emailToContact = new Map<String,Contact>();

        List<String> existingContactsEmails = Utils.mapToString(ContactHandler.retrieveContactsWithEmails(Utils.mapToString(contacts, Contact.Email_External_Id__c)), Contact.Email_External_Id__c);

        for (Integer i = 0; i < accounts.size(); i++) {
            if (!existingContactsEmails.contains(contacts[i].Email_External_Id__c)
                && !emailToContact.containsKey(contacts[i].Email_External_Id__c)) {
             	emailToAccount.put(contacts[i].Email_External_Id__c,accounts[i]);
                emailToContact.put(contacts[i].Email_External_Id__c,contacts[i]);
            }
        }

        // Accounts IDs will get inserted to the map values
        DatabaseManager.insertListPartialEnabled(emailToAccount.values()); 
        
        for (String email: emailToContact.keySet()) {
            emailToContact.get(email).AccountId = emailToAccount.get(email).Id;
        }       
        DatabaseManager.insertListPartialEnabled(emailToContact.values());
    }

    
    public static void insertDary(List<Dar__c> dary) {

        DatabaseManager.insertListPartialEnabled(dary);
    }


    public static void insertNominations(List<Nominace__c> nominations) {

        DatabaseManager.insertListPartialEnabled(nominations);
    }


    public static void insertContracts(List<Contract__c> contracts) {

        DatabaseManager.insertListPartialEnabled(contracts);
    }

    public static void insertGrounds(List<Ground__c> grounds) {

        Map<Decimal, List<Ground__c>> existingGrounds = GroundHandler.getGroundsForContractIds(Utils.mapToDecimal(Utils.mapToSObject(grounds, Ground__c.Pachtovni_smlouva__c), Contract__c.Ziva_Puda_ID__c));

        List<Ground__c> groundsToInsert = new List<Ground__c>();

        for (Ground__c ground: grounds) {
            if (!existingGrounds.containsKey((Integer)ground.Pachtovni_smlouva__r.Ziva_Puda_ID__c)
             || !Utils.mapToString(existingGrounds.get((Integer)ground.Pachtovni_smlouva__r.Ziva_Puda_ID__c), Ground__c.ID_Parcely__c).contains(ground.ID_Parcely__c)) {
                groundsToInsert.add(ground);
            }
        }

        if (grounds.size() != groundsToInsert.size()) {
            Logger.log((grounds.size() - groundsToInsert.size()) + ' grounds were omitted from insertion due to duplicities');
        }

        DatabaseManager.insertListPartialEnabled(groundsToInsert);
    }
}
