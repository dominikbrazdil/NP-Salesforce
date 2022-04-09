public without sharing class DarHandler {

    private String name;
    private Date datum;
    private Decimal darovanaCastka;
    private Decimal prijataCastka;
    private Integer transactionId;
    private Boolean pravidelnyDar;
    private Boolean pozadujePotvrzeni;
    private Boolean darovanoNaVyzvu;
    private String zdroj;
    private Integer capmaignId;
    private String donorEmail; 
	
    public Dar__c build() {
        Campaign campaign = new Campaign(Darujme_Id__c = this.capmaignId);
        Contact donor = new Contact(Email_External_Id__c = this.donorEmail);

        return new Dar__c(
            Name = this.name,
            Datum__c = this.datum,
            Darovana_castka__c = this.darovanaCastka,
            Prijata_castka__c = this.prijataCastka,
            Transaction_Id__c = this.transactionId,
            Pravidelny_dar__c = this.pravidelnyDar,
            Kampan__r = campaign,
            Pozaduje_potvrzeni__c = this.pozadujePotvrzeni,
            Darovano_na_vyzvu__c = this.darovanoNaVyzvu,
            Zdroj__c = this.zdroj,
            Darce__r = donor
        );
    }

    public DarHandler setName(String name) {
        this.name = name;
        return this;
    }

    public DarHandler setDatum(Date datum) {
        this.datum = datum;
        return this;
    }

    public DarHandler setDarovanaCastka(Decimal darovanaCastka) {
        this.darovanaCastka = darovanaCastka;
        return this;
    }

    public DarHandler setPrijataCastka(Decimal prijataCastka) {
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

    public DarHandler setZdroj(String zdroj) {
        this.zdroj = zdroj;
        return this;
    }

    public DarHandler setCampaignId(Integer capmaignId) {
        this.capmaignId = capmaignId;
        return this;
    }

    public DarHandler setDonorEmail(String donorEmail) {
        if (!String.isEmpty(donorEmail)) {
            this.donorEmail = donorEmail.toLowerCase();
        }
        return this;
    }
    
}