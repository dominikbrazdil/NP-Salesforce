/**
 * Class representing data response coming from Darujme transaction endpoint
 */
public class TransactionsAPIResponse {
	public List<DarujmeTransaction> transactions;

	public static TransactionsAPIResponse parse(String json) {
		return (TransactionsAPIResponse) System.JSON.deserialize(json, TransactionsAPIResponse.class);
	}
}