public without sharing class DarHandler {

    private String receivedDate; // YYYY-MM-DD format
    private Integer darovanaCastka;
    private Integer prijataCastka;
    private Integer transactionId;
    private Boolean pravidelnyDar;
    private Boolean pozadujePotvrzeni;
    private Boolean darovanoNaVyzvu;
    private Integer capmaignId;
    private String donorEmail; 
	
    public Dar__c build() {
        Campaign campaign = new Campaign(Darujme_Id__c = this.capmaignId);
        Contact donor = new Contact(Email_External_Id__c = this.donorEmail);

        return new Dar__c(
            Name = this.receivedDate,
            Datum__c = Date.valueOf(this.receivedDate),
            Darovana_castka__c = this.darovanaCastka,
            Prijata_castka__c = this.prijataCastka,
            Transaction_Id__c = this.transactionId,
            Pravidelny_dar__c = this.pravidelnyDar,
            Kampan__r = campaign,
            Pozaduje_potvrzeni__c = this.pozadujePotvrzeni,
            Darovano_na_vyzvu__c = this.darovanoNaVyzvu,
            Darce__r = donor
        );
    }

    public DarHandler setReceivedDate(String receivedDate) {
        this.receivedDate = receivedDate;
        return this;
    }

    public DarHandler setDarovanaCastka(Integer darovanaCastka) {
        this.darovanaCastka = darovanaCastka;
        return this;
    }

    public DarHandler setPrijataCastka(Integer prijataCastka) {
        this.prijataCastka = prijataCastka;
        return this;
    }

    public DarHandler setTransactionId(Integer transactionId) {
        this.transactionId = transactionId;
        return this;
    }

    public DarHandler setPravidelnyDar(Boolean pravidelnyDar) {
        this.pravidelnyDar = pravidelnyDar;
        return this;
    }

    public DarHandler setPozadujePotvrzeni(Boolean pozadujePotvrzeni) {
        this.pozadujePotvrzeni = pozadujePotvrzeni;
        return this;
    }

    public DarHandler setDarovanoNaVyzvu(Boolean darovanoNaVyzvu) {
        this.darovanoNaVyzvu = darovanoNaVyzvu;
        return this;
    }

    public DarHandler setCampaignId(Integer capmaignId) {
        this.capmaignId = capmaignId;
        return this;
    }

    public DarHandler setDonorEmail(String donorEmail) {
        this.donorEmail = donorEmail.toLowerCase();
        return this;
    }
    
}