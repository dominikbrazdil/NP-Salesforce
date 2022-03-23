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
        return [SELECT ContactId, CampaignId FROM CampaignMember WHERE ContactId IN :contactIds];
    }

    public static Map<Id, List<Id>> getContactsCampaignsMap(List<Id> contactIds) {
        Map<Id, List<Id>> contactToCampaigns = new Map<Id, List<Id>>();

        for(CampaignMember m: getMembersByContactIds(contactIds)) {
            if (contactToCampaigns.containsKey(m.ContactId)) {
                contactToCampaigns.get(m.ContactId).add(m.CampaignId);
            } else {
                contactToCampaigns.put(m.ContactId, new List<Id>{m.CampaignId});
            }
        }
        return contactToCampaigns;
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
