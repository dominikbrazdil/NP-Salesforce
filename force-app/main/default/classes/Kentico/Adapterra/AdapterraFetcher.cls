/**
 * Implmementation of DataFetcher interface for Adapterra
 */
public class AdapterraFetcher extends DataFetcher {
    
    public AdapterraFetcher() {
        this.API_SECRET = Credentials__c.getInstance().Adapterra_API_secret__c;
        this.API_URL ='https://www.adapterraawards.cz/cs/Specialni-stranky/';
    }

    protected override String getEndpointAuthorisation() {
        return 'apiKey=' + API_SECRET;
    }

    protected override String replaceReservedWordsInJSON(String responseJSON) {
        return responseJSON;
    }

    public List<Nomination> getNominations(Date fromDate, Date toDate) {
        String endpoint = 'api-prihlasky?fromDate=' + ((Datetime)fromDate).format('MM-dd-yyyy') + (toDate==null ? '' : '&toDate='+((Datetime)toDate).format('MM-dd-yyyy'));
        String response = fetchData(endpoint);
        return Nomination.parse(response);
    }
}