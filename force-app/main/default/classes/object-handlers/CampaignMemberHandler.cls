public class CampaignMemberHandler {
    
    private Id campaignId;
    private Id contactId;
    
    public CampaignMember build() {
        return new CampaignMember(
            CampaignId=this.campaignId,
            ContactId=this.contactId
        );
    }

    public static List<CampaignMember> getMembersByContactIds(List<Id> contactIds) {
        return [SELECT Id, ContactId, CampaignId FROM CampaignMember WHERE ContactId IN :contactIds];
    }

    public static Map<Id, Map<Id, Id>> getContactIdsToCampaignsIdsToMemberIdMap(List<Id> contactIds) {
        Map<Id, Map<Id, Id>> contactToCampaigns = new Map<Id, Map<Id, Id>>();

        for(CampaignMember m: getMembersByContactIds(contactIds)) {
            if (contactToCampaigns.containsKey(m.ContactId)) {
                contactToCampaigns.get(m.ContactId).put(m.CampaignId, m.Id);
            } else {
                contactToCampaigns.put(m.ContactId, new Map<Id, Id>{m.CampaignId => m.Id});
            }
        }
        return contactToCampaigns;
    }

    public static Boolean isContactInCampaign(Id contactId, Id campaignId, Map<Id, Map<Id, Id>> contactToCampaigns) {
        return (contactToCampaigns.containsKey(contactId) && contactToCampaigns.get(contactId).containsKey(campaignId));
    }

    public CampaignMemberHandler setCampaignId(Id campaignId) {
        this.campaignId = campaignId;
        return this;
    }

    public CampaignMemberHandler setContactId(Id contactId) {
        this.contactId = contactId;
        return this;
    }
}
