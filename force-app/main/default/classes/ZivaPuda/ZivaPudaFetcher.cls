public class ZivaPudaFetcher extends DataFetcher {
    
    public ZivaPudaFetcher() {
        this.API_SECRET = Credentials__c.getInstance().Ziva_Puda_API_Secret__c;
        this.API_URL = 'https://p.propudu.cz/api/';
    }

    protected override String getEndpointAuthorisation() {
        return 'apiKey=' + API_SECRET;
    }

    protected override String replaceReservedWordsInJSON(String responseJSON) {
        return responseJSON.replace('"date"', '"signingDate"');
    }


    public List<ZivaPudaContract> getContracts(Date fromDate, Date toDate) {
        if (toDate == null) {
            toDate = Date.today();
        }

        String endpoint = 'SF-Pacht-smlouvy?from=' + ((Datetime)fromDate).format('MM-dd-yyyy') + '&to='+((Datetime)toDate).format('MM-dd-yyyy');
        // String json = '[{ "id": 111, "url": "https://p.propudu.cz/Specialni/Pachtovni-smlouva/1653485613086", "date": "25.05.2022 15:38:13", "email": "michal.kuk@gmail.com", "owners": [ { "name": "Michal", "birthdate": "0012-12-12", "address": "Praha" } ], "lessee": { "name": "Pavel", "ICO": "123", "headquarters": "Brno" }, "grounds": [ { "id": 1, "uzemi": "sdf", "parcelID": "sdf", "type": "Ovocné sady", "area": "123" } ], "leasePeriod": { "type": "na dobu určitou", "howLong": 3 }, "rent": 25000, "obligations": { "pledge": [ "nebude na pozemku evidovaném v LPIS jako orná půda pěstovat kukuřici pro výrobu bioplynu a štěpku pro energetické využití,", "nebude pozemky osévat geneticky modifikovaným plodinami," ], "mandatoryMeasures": { "type": "obecné" } }, "resignation": { "lessee": "12měsíční", "owner": "12měsíční", "ownerElse": "bez výpovědní doby", "articles": "6.1 až 6.7" }, "sanctions": false }]';
        String response = fetchData(endpoint);
        return ZivaPudaContract.parse(response);
    }
}
