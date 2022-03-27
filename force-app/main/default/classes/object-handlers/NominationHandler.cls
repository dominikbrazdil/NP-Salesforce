public without sharing class NominationHandler {
    
    private String name;
    private String nominatedEmail;
    private String nominatingEmail;
    private String kategorie;
    private String zamereni;

    public Nominace__c build() {
        Contact nominated;
        if (this.nominatedEmail != null) {
            nominated = new Contact(Email_External_Id__c=this.nominatedEmail);
        }
        Contact nominating = new Contact(Email_External_Id__c=this.nominatingEmail);

        return new Nominace__c(
            Name=this.name,
            Kategorie__c=this.kategorie,
            Zamereni__c=this.zamereni,
            Nominovany__r=nominated,
            Nominujici__r=nominating
        );
    }

    public NominationHandler setName(String name) {
        if (!String.isEmpty(name)) {
            this.name = name.left(80);
        }
        return this;
    }

    public NominationHandler setKategorie(String kategorie) {
        this.kategorie = kategorie;
        return this;
    }

    public NominationHandler setZamereni(String zamereni) {
        if (!String.isEmpty(zamereni)) {
            this.zamereni = zamereni.left(200);
        }
        return this;
    }

    public NominationHandler setNominatingEmail(String email) {
        if (!String.isEmpty(email)) {
            this.nominatingEmail = email.toLowerCase();
        }
        return this;
    }

    public NominationHandler setNominatedEmail(String email) {
        if (!String.isEmpty(email)) {
            this.nominatedEmail = email.toLowerCase();
        }
        return this;
    }
}
