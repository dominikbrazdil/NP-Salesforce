public without sharing class NominationHandler {
    
    private Integer id;
    private String name;
    private String contactEmail;
    private String category;
    private String location;
    private String gps;
    private String description;
    private String web;
    private String kraj;
    private Datetime created;

    public Nominace__c build() {
        Contact nominating = new Contact(Email_External_Id__c=this.contactEmail);

        return new Nominace__c(
            External_Id__c=this.id,
            Name=this.name,
            Kategorie__c=this.category,
            Lokalita_stromu__c=this.location,
            GPS_stromu__c=this.gps,
            Popis__c=this.description,
            Kraj_navrhovatel__c=this.kraj,
            Web__c=this.web,
            Created__c=this.created,
            Nominujici__r=nominating
        );
    }

    public NominationHandler setId(Integer id) {
        this.id = id;
        return this;
    }

    public NominationHandler setName(String name) {
        if (!String.isEmpty(name)) {
            this.name = name.left(80);
        }
        return this;
    }

    public NominationHandler setCategory(String category) {
        this.category = category;
        return this;
    }

    public NominationHandler setLocation(String location) {
        this.location = location;
        return this;
    }

    public NominationHandler setGps(String gps) {
        this.gps = gps;
        return this;
    }

    public NominationHandler setDescription(String description) {
        this.description = description;
        return this;
    }

    public NominationHandler setKraj(String kraj) {
        this.kraj = kraj;
        return this;
    }

    public NominationHandler setWeb(String web) {
        this.web = web;
        return this;
    }

    public NominationHandler setCreated(Datetime created) {
        this.created = created;
        return this;
    }

    public NominationHandler setContactEmail(String email) {
        if (!String.isEmpty(email)) {
            this.contactEmail = email.toLowerCase();
        }
        return this;
    }
}
