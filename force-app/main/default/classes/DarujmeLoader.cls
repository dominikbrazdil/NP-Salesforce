public class DarujmeLoader {
    private static final Integer API_ID = 74234201;
    private static final String API_SECRET = 'ekkzdy6n424qlnxts0siqp1v2quzyihk18lawj2e';
    private static final Integer ORGANIZATION_ID = 1200442;

    private static final String TRANSACTIONS_URL = 'https://www.darujme.cz/api/v1/' + 
                           'organization/' + ORGANIZATION_ID +
                           '/transactions-by-filter?' +
                           'apiId=' + API_ID + 
                           '&apiSecret=' + API_SECRET;


    private static Http http = new Http();

    // import only transactions with this state of transaction
    public static final DarujmeTransaction.TransactionState[] TRANSACTION_STATES_TO_IMPORT = new DarujmeTransaction.TransactionState[]{
        DarujmeTransaction.TransactionState.SENT_TO_ORGANIZATION,
        DarujmeTransaction.TransactionState.SUCCESS_MONEY_ON_ACCOUNT
    };

    /**
     * 
     * fromDate - YYYY-MM-DD
     */
    public static void loadTransactions(String fromDate, String toDate) {
        Logger.log('Importing transactions from ' + fromDate + ' to ' + (toDate == null ? System.today().format() : toDate));

    	HttpRequest r = new HttpRequest();
        r.setMethod('GET');
        String endpoint = (TRANSACTIONS_URL + '&fromReceivedDate=' + fromDate + (toDate==null ? '' : '&toReceivedDate='+toDate));
        r.setEndpoint(endpoint); 
		HttpResponse res = http.send(r);
        
        String jsonToParse = replaceReservedWordsInJSON(res.getBody());
        List<DarujmeTransaction> transactions = ((TransactionsAPIResponse) JSON.deserialize(jsonToParse, TransactionsAPIResponse.class)).transactions;
        List<DarujmeTransaction> transactionsToImport = filterTransactionsForImport(transactions);
        Logger.log('Transactions to be inserted: ' + transactionsToImport);

        Map<Integer,DarujmePromotion> promotions = loadAssociatedPromotionsFromUpstream(transactionsToImport);

        DarujmeImporter.importTransactions(transactionsToImport, promotions);
    }

    private static Map<Integer, DarujmePromotion> loadAssociatedPromotionsFromUpstream(List<DarujmeTransaction> transactions) {
        Map<Integer, DarujmePromotion> loadedPromotions = new Map<Integer, DarujmePromotion>();

        Set<Integer> promotionIds = new Set<Integer>();

        for (DarujmeTransaction tr: transactions) {
            if (tr.pledge.promotionId != null & !promotionIds.contains(tr.pledge.promotionId)) {
                promotionIds.add(tr.pledge.promotionId);
                loadedPromotions.put(tr.pledge.promotionId, loadPromotionById(tr.pledge.promotionId));
            }
        }

        return loadedPromotions;
    }

    private static DarujmePromotion loadPromotionById(Integer id) {
        HttpRequest r = new HttpRequest();
        r.setMethod('GET');
        r.setEndpoint('https://www.darujme.cz/api/v1/' + 
            'promotion/' + id +
            '?apiId=' + API_ID + 
            '&apiSecret=' + API_SECRET); 
		HttpResponse res = http.send(r);
        
        String jsonToParse = replaceReservedWordsInJSON(res.getBody());
        return ((PromotionAPIResponse) JSON.deserialize(jsonToParse, PromotionAPIResponse.class)).promotion;
    }

    private static List<DarujmeTransaction> filterTransactionsForImport(List<DarujmeTransaction> transactions) {
        List<DarujmeTransaction> transactionsToImport = new List<DarujmeTransaction>();
        for (DarujmeTransaction tr: transactions) {
            if (TRANSACTION_STATES_TO_IMPORT.contains(tr.state)) {
                transactionsToImport.add(tr);
            }
        }
        return transactionsToImport;
    }

    private static String replaceReservedWordsInJSON(String responseJSON) {
        return responseJSON.replace('currency', 'usedCurrency');
    }


}