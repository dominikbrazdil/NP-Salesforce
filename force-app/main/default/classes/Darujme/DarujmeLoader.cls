/**
 * Class collecting, filtering and mapping all Darujme transactions for the specified timespan
 */
public class DarujmeLoader {

    private static DarujmeFetcher fetcher = new DarujmeFetcher();

    // import only transactions with this state of transaction
    public static final DarujmeTransaction.TransactionState[] TRANSACTION_STATES_TO_IMPORT = new DarujmeTransaction.TransactionState[]{
        DarujmeTransaction.TransactionState.SENT_TO_ORGANIZATION,
        DarujmeTransaction.TransactionState.SUCCESS_MONEY_ON_ACCOUNT
    };

    /**
     * Main method representing class public interface - loading transactions between defined timespan
     * fromDate - YYYY-MM-DD
     * toDate - YYYY-MM-DD
     */
    public static void loadTransactions(Date fromDate, Date toDate) {
        Logger.log('Importing transactions from ' + fromDate.format() + ' to ' + (toDate == null ? System.today().format() : toDate.format()));
        
        List<DarujmeTransaction> transactions = fetcher.getTransactions(fromDate, toDate);
        List<DarujmeTransaction> transactionsToImport = filterTransactionsForImport(transactions);
        Logger.log(transactionsToImport.size() + ' Transactions to be inserted: ' + transactionsToImport);

        Map<Integer,DarujmePromotion> promotions = loadAssociatedPromotions(transactionsToImport);

        importTransactions(transactionsToImport, promotions);
    }

    /**
     * Invokes importing of preprocessed transactions and promotions
     */
    @TestVisible
    private static void importTransactions(List<DarujmeTransaction> transactions, Map<Integer,DarujmePromotion> promotions) {
        Importer.insertNonExistingContactsWithAccounts(mapToAccounts(transactions), mapToContacts(transactions));
        Importer.insertDary(mapToDary(transactions, promotions));
    }

    private static List<Account> mapToAccounts(List<DarujmeTransaction> transactions) {
        List<Account> accs = new List<Account>();
        for (DarujmeTransaction tr: transactions) {
            accs.add(tr.createAccount());
        }
        return accs;
    }

    private static List<Contact> mapToContacts(List<DarujmeTransaction> transactions) {
        List<Contact> contacts = new List<Contact>();
        for (DarujmeTransaction tr: transactions) {
            contacts.add(tr.createContact());
        }
        return contacts;
    }

    private static List<Dar__c> mapToDary(List<DarujmeTransaction> transactions, Map<Integer,DarujmePromotion> promotions) {
        List<Dar__c> dary = new List<Dar__c>();
        for (DarujmeTransaction tr: transactions) {
            Dar__c dar = tr.createDar();
            if (dar.Darovano_na_vyzvu__c) {
                dar.Vyzva__c = promotions.get(tr.pledge.promotionId).title.cs;
            }
            dary.add(dar);
        }
        return dary;
    }

    /**
     * Loads all promotions specified in given transactions from endpoint
     */
    private static Map<Integer, DarujmePromotion> loadAssociatedPromotions(List<DarujmeTransaction> transactions) {
        Map<Integer, DarujmePromotion> loadedPromotions = new Map<Integer, DarujmePromotion>();

        Set<Integer> promotionIds = new Set<Integer>();

        for (DarujmeTransaction tr: transactions) {
            if (tr.pledge.promotionId != null & !promotionIds.contains(tr.pledge.promotionId)) {
                promotionIds.add(tr.pledge.promotionId);
                loadedPromotions.put(tr.pledge.promotionId, fetcher.getPromotion(tr.pledge.promotionId));
            }
        }

        return loadedPromotions;
    }

    /**
     * Filters those transactions that are meant to be imported by given rules
     */
    private static List<DarujmeTransaction> filterTransactionsForImport(List<DarujmeTransaction> transactions) {
        List<DarujmeTransaction> transactionsToImport = new List<DarujmeTransaction>();
        for (DarujmeTransaction tr: transactions) {
            if (TRANSACTION_STATES_TO_IMPORT.contains(tr.state)) {
                transactionsToImport.add(tr);
            }
        }
        return transactionsToImport;
    }



}