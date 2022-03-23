public class Importer {
    
    public static void insertNonExistingContactsWithAccounts(List<Account> accounts, List<Contact> contacts) {

        if (accounts.size() != contacts.size()) {
            Logger.log(LoggingLevel.ERROR, 'Accounts and contacts size is not the same.');
            return;
        }

        List<Account> accountsToAdd = new List<Account>();
        List<Contact> contactsToAdd = new List<Contact>();

        List<String> existingContactsEmails = Utils.mapToString(ContactHandler.retrieveContactsWithEmails(Utils.mapToString(contacts, Contact.Email_External_Id__c)), Contact.Email_External_Id__c);

        for (Integer i = 0; i < accounts.size(); i++) {
            if (!existingContactsEmails.contains(contacts[i].Email_External_Id__c)
                && !Utils.mapToString(contactsToAdd, Contact.Email_External_Id__c).contains(contacts[i].Email_External_Id__c)) {
             	accountsToAdd.add(accounts[i]);
                contactsToAdd.add(contacts[i]);
            }
        }

        // Accounts IDs will get inserted to the map values
        DatabaseManager.insertListPartialEnabled(accountsToAdd); 
        
        for (Integer i = 0; i < contactsToAdd.size(); i++) {
            contactsToAdd[i].AccountId = accountsToAdd[i].Id;
        }       
        DatabaseManager.insertListPartialEnabled(contactsToAdd);
    }


    
    public static void insertDary(List<Dar__c> dary) {

        List<String> existingContactsEmails = Utils.mapToString(ContactHandler.retrieveContactsWithEmails(Utils.mapToString(Utils.mapToSObject(dary, Dar__c.Darce__c), Contact.Email_External_Id__c)), Contact.Email_External_Id__c);
        List<Dar__c> daryToAdd = new List<Dar__c>();

        for (Dar__c dar: dary) {
            if (!existingContactsEmails.contains(dar.Darce__r.Email_external_Id__c)) {
                Logger.log(LoggingLevel.ERROR, System.StatusCode.INVALID_FIELD + ': Dar cannot be created, contact with email ' + dar.Darce__r.Email_external_Id__c + ' does not exist.');
            } else {
                daryToAdd.add(dar);
            }
        }

        DatabaseManager.insertListPartialEnabled(daryToAdd);
    }


    public static void insertNominations(List<Nominace__c> nominations) {

        Set<String> nominationsEmails = new Set<String>();
        nominationsEmails.addAll(Utils.mapToString(Utils.mapToSObject(nominations, Nominace__c.Nominovany__c), Contact.Email_External_Id__c));
        nominationsEmails.addAll(Utils.mapToString(Utils.mapToSObject(nominations, Nominace__c.Nominujici__c), Contact.Email_External_Id__c));

        List<String> existingContactsEmails = Utils.mapToString(ContactHandler.retrieveContactsWithEmails(new List<String>(nominationsEmails)), Contact.Email_External_Id__c);
        List<Nominace__c> nomsToAdd = new List<Nominace__c>();

        for (Nominace__c n: nominations) {
            if (!existingContactsEmails.contains(n.Nominujici__r.Email_external_Id__c)) {
                Logger.log(LoggingLevel.ERROR, System.StatusCode.INVALID_FIELD + ': Nomination cannot be created, contact with email ' + n.Nominujici__r.Email_external_Id__c + ' does not exist.');
            } else if (!existingContactsEmails.contains(n.Nominovany__r.Email_external_Id__c)){
                Logger.log(LoggingLevel.ERROR, System.StatusCode.INVALID_FIELD + ': Nomination cannot be created, contact with email ' + n.Nominovany__r.Email_external_Id__c + ' does not exist.');
            } else {
                nomsToAdd.add(n);
            }
        }

        DatabaseManager.insertListPartialEnabled(nomsToAdd);
    }
}
