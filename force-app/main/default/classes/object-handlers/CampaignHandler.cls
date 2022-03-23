public without sharing class CampaignHandler {
    
    private String name;
    private Date startedDate;
    private Id programId;
    private Integer darujmeId;

    public Campaign build() {
        return new Campaign(
            Name=this.name,
            StartDate=this.startedDate,
            Program__c=this.programId,
            Darujme_Id__c=this.darujmeId
        );
    }

    public static Campaign getLatestCampaignFromProgram(Integer npProgramId) {
        return [SELECT Id, Name, StartDate FROM Campaign WHERE Program__r.NP_Id__c =:npProgramId ORDER BY StartDate DESC LIMIT 1];
    }

    public CampaignHandler setName(String name) {
        this.name = name;
        return this;
    }

    public CampaignHandler setStartDate(Date startDate) {
        this.startedDate = startDate;
        return this;
    }

    public CampaignHandler setProgramId(Id programId) {
        this.programId = programId;
        return this;
    }

    public CampaignHandler setDarujmeId(Integer darujmeId) {
        this.darujmeId = darujmeId;
        return this;
    }
}
