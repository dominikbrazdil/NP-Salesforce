public class PromotionAPIResponse {
    public DarujmePromotion promotion;

    public static PromotionAPIResponse parse(String json) {
		return (PromotionAPIResponse) System.JSON.deserialize(json, PromotionAPIResponse.class);
	}
}
