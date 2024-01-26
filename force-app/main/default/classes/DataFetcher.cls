/**
 * Interface class predefining common functionality for fetching data from endpoint
 */
public abstract class DataFetcher {

    protected final String API_URL;
    protected final String API_SECRET;

    private Http http = new Http();


    protected String fetchData(String endpointString) {
        HttpRequest r = new HttpRequest();
        r.setMethod('GET');
        String endpoint = API_URL
            + endpointString
            + (endpointString.contains('?') ? '&' : '?')
            + getEndpointAuthorisation();
        r.setEndpoint(endpoint); 
        r.setTimeout(20000);
		HttpResponse res = http.send(r);
        
        if (res.getStatusCode() != 200) {
            Logger.log(LoggingLevel.ERROR, 'Failed to fetch data from ' + endpoint + '. Response: ' + res.toString());
            throw new CalloutException(res.toString());
        }

        String resBody = res.getBody().replaceAll('\\p{Cc}', ''); // remove structural chars
        return replaceReservedWordsInJSON(resBody);
    }

    protected abstract String getEndpointAuthorisation();

    protected abstract String replaceReservedWordsInJSON(String responseJSON);
 }
