/**
 * Implementation of DataFetcher interface for Darujme.cz
 */
public class DarujmeFetcher extends DataFetcher {

    private final Integer API_ID = 74234201;
    private final Integer ORGANIZATION_ID = 1200442;

    public DarujmeFetcher() {
        this.API_SECRET = Credentials__c.getInstance().darujme_API_secret__c;
        this.API_URL = 'https://www.darujme.cz/api/v1/';
    }

    protected override String getEndpointAuthorisation() {
        return 'apiId=' + API_ID + '&apiSecret=' + API_SECRET;
    }

    protected override String replaceReservedWordsInJSON(String responseJSON) {
        return responseJSON.replace('currency', 'usedCurrency');
    }

    public List<DarujmeTransaction> getTransactions(Date fromDate, Date toDate) {
        String endpoint = 'organization/' + ORGANIZATION_ID + '/transactions-by-filter?fromReceivedDate=' + ((Datetime)fromDate).format('yyyy-MM-dd') + (toDate==null ? '' : '&toReceivedDate='+((Datetime)toDate).format('yyyy-MM-dd'));
        String response = fetchData(endpoint);
        return TransactionsAPIResponse.parse(response).transactions;
    }

    public DarujmePromotion getPromotion(Integer promotionId) {
        String endpoint = 'promotion/' + promotionId;
        String response = fetchData(endpoint);
        return PromotionAPIResponse.parse(response).promotion;
    }
}
