public class AdapterraFetcher extends DataFetcher {
    
    public AdapterraFetcher() {
        this.API_SECRET = 'gbp!dxq8UPD1krx_wkw';
        this.API_URL ='https://www.adapterraawards.cz/cs/Specialni-stranky/';
    }

    protected override String getEndpointAuthorisation() {
        return 'apiKey=' + API_SECRET;
    }

    protected override String replaceReservedWordsInJSON(String responseJSON) {
        return responseJSON;
    }

    public List<Nomination> getNominations(Date fromDate, Date toDate) {
        String endpoint = 'api-prihlasky?fromDate=' + ((Datetime)fromDate).format('dd-MM-yyyy') + (toDate==null ? '' : '&toDate='+((Datetime)toDate).format('dd-MM-yyyy'));
        String response = fetchData(endpoint);
        return Nomination.parse(response);
    }
}
