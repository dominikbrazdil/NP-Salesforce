public with sharing class ContractHandler {
    
    private Integer id;
    private String ownerEmail;
    private Integer ownerBirthYear;
    private String ownerAddress;
    private String lesseeName;
    private String lesseeICO;
    private String lesseeAddress;
    private String name;
    private Datetime signingDate;
    private String otherOwners;
    private Decimal rent;
    private Integer rentPeriod;
    private Integer noticePeriod;
    private String type;
    private String pledges;
    private String measuresType;
    private String lesseeResignation;
    private String ownerResignation;
    private String ownerElseResignation;
    private String articles;
    private Boolean sanctions;
    private String url;


    public Contract__c build() {
        Contact owner =  new Contact(Email_External_Id__c=this.ownerEmail);

        return new Contract__c(
            Name = this.name,
            Ziva_Puda_ID__c = this.id,
            Vlastnik__r = owner,
            Vlastnik_rok_narozeni__c = this.ownerBirthYear,
            Vlastnik_adresa__c = this.ownerAddress,
            Najemnik_jmeno__c = this.lesseeName,
            Najemnik_ICO__c = this.lesseeICO,
            Najemnik_adresa__c = this.lesseeAddress,
            Datum__c = this.signingDate,
            Dalsi_vlastnici__c = this.otherOwners,
            Najem__c = this.rent,
            Doba__c = this.rentPeriod,
            Oznamovaci_doba__c = this.noticePeriod,
            Typ__c = this.type,
            Zavazky__c = this.pledges,
            Najemce_vypovedni_lhuta__c = this.lesseeResignation,
            Majitel_vypovedni_lhuta__c = this.ownerResignation,
            Majitel_vypoved_jinak__c = this.ownerElseResignation,
            Clanky__c = this.articles,
            Sankce__c = this.sanctions,
            Typ_opatreni__c = this.measuresType,
            PDF__c = this.url
        );
    }

    public ContractHandler setID(Integer id) {
        this.id = id;
        return this;
    }

    public ContractHandler setName(String name) {
        this.name = name;
        return this;
    }

    public ContractHandler setOwnerEmail(String email) {
        this.ownerEmail = email;
        return this;
    }

    public ContractHandler setOwnerBirthYear(Integer year) {
        this.ownerBirthYear = year;
        return this;
    }

    public ContractHandler setOwnerAddress(String address) {
        this.ownerAddress = address;
        return this;
    }

    public ContractHandler setLesseeName(String name) {
        this.lesseeName = name;
        return this;
    }

    public ContractHandler setLesseeICO(String ICO) {
        this.lesseeICO = ICO;
        return this;
    }

    public ContractHandler setLesseeAddress(String address) {
        this.lesseeAddress = address;
        return this;
    }

    public ContractHandler setSigningDate(Datetime d) {
        this.signingDate = d;
        return this;
    }

    public ContractHandler setOtherOwners(List<String> owners) {
        this.otherOwners = String.join(owners, '\n');
        return this;
    }

    public ContractHandler setRent(Decimal rent) {
        this.rent = rent;
        return this;
    }

    public ContractHandler setRentPeriod(Integer period) {
        this.rentPeriod = period;
        return this;
    }

    public ContractHandler setNoticePeriod(Integer period) {
        this.noticePeriod = period;
        return this;
    }

    public ContractHandler setType(String type) {
        this.type = type;
        return this;
    }

    public ContractHandler setPledges(List<String> pledges) {
        this.pledges = String.join(pledges, '\n');
        return this;
    }

    public ContractHandler setMeasuresType(String type) {
        this.measuresType = type;
        return this;
    }

    public ContractHandler setLesseeResignation(String resignation) {
        this.lesseeResignation = resignation;
        return this;
    }

    public ContractHandler setOwnerResignation(String resignation) {
        this.ownerResignation = resignation;
        return this;
    }

    public ContractHandler setOwnerElseResignation(String resignation) {
        this.ownerElseResignation = resignation;
        return this;
    }

    public ContractHandler setArticles(String articles) {
        this.articles = articles;
        return this;
    }

    public ContractHandler setSanctions(Boolean sanctions) {
        this.sanctions = sanctions;
        return this;
    }

    public ContractHandler setURL(String url) {
        this.url = url;
        return this;
    }
}
