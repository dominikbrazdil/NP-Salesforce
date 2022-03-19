public class DarujmeImporter {

    public static void importTransactions(List<DarujmeTransaction> transactions, Map<Integer, DarujmePromotion> promotions) {
        insertNonExistingContactsWithAccounts(transactions);
        insertDary(transactions, promotions);
    }
    
    @TestVisible
    private static void insertNonExistingContactsWithAccounts(List<DarujmeTransaction> transactions) {
        List<Account> accountsToAdd = new List<Account>(); 
        List<Contact> contactsToAdd = new List<Contact>(); 

        List<String> existingContactsEmails = Utils.mapToString(getExistingContactsFromTransactions(transactions), Contact.email);

        for (DarujmeTransaction tr: transactions) {
            if (!existingContactsEmails.contains(tr.pledge.donor.email.toLowerCase())
                && !Utils.mapToString(contactsToAdd, Contact.email).contains(tr.pledge.donor.email.toLowerCase())) {
             	accountsToAdd.add(AccountHandler.build(tr));
                contactsToAdd.add(ContactHandler.build(tr, null));
            }
        }

        // Accounts IDs will get inserted to the map values
        DatabaseManager.insertListPartialEnabled(accountsToAdd); 
        
        for (Integer i = 0; i < contactsToAdd.size(); i++) {
            contactsToAdd[i].AccountId = accountsToAdd[i].Id;
        }       
        DatabaseManager.insertListPartialEnabled(contactsToAdd);
    }

    private static List<Contact> getExistingContactsFromTransactions(List<DarujmeTransaction> transactions) {
        Set<String> transactionsContactEmails = new Set<String>();
        for (DarujmeTransaction tr: transactions) { 
            transactionsContactEmails.add(tr.pledge.donor.email);
        }

        return ContactHandler.retrieveContactsWithEmails(transactionsContactEmails);
    }

    @TestVisible
    private static void insertDary(List<DarujmeTransaction> transactions, Map<Integer,DarujmePromotion> promotions) {

        List<Contact> existingContacts = getExistingContactsFromTransactions(transactions);
        Set<Dar__c> daryToAdd = new Set<Dar__c>();

        for (DarujmeTransaction tr: transactions) {
            Contact contact = (Contact)Utils.find(existingContacts, Contact.email, tr.pledge.donor.email);
            if (contact == null) {
                Logger.log(LoggingLevel.ERROR, System.StatusCode.INVALID_FIELD + ': Dar cannot be created, contact with email ' + tr.pledge.donor.email + ' does not exist.');
            } else {
                Dar__c newDar = DarHandler.build(contact, tr);
                if (tr.sentAmount.usedCurrency != DarujmeTransaction.CurrencyType.CZK) {
                    Logger.log(LoggingLevel.WARN, 'This transaction currency is not CZK: ' + tr);
                }
                if (newDar.Darovano_na_vyzvu__c) {
                    assignPromotionToDar(newDar, promotions, tr.pledge.promotionId);
                }
                daryToAdd.add(newDar);
            }
        }

        DatabaseManager.insertListPartialEnabled(new List<Dar__c>(daryToAdd));
    }

    private static void assignPromotionToDar(Dar__c dar, Map<Integer, DarujmePromotion> promotions, Integer promotionId) {
        DarujmePromotion pr = promotions.get(promotionId);
        if (pr != null && pr.title.cs != null) {
            dar.Vyzva__c = pr.title.cs;
        }
    }
}
