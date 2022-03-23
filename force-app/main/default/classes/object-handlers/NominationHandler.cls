public without sharing class NominationHandler {
    
    private String name;
    private String nominatedEmail;
    private String nominatingEmail;

    public Nominace__c build() {
        Contact nominated = new Contact(Email_External_Id__c=this.nominatedEmail);
        Contact nominating = new Contact(Email_External_Id__c=this.nominatingEmail);

        return new Nominace__c(
            Name=this.name,
            Nominovany__r=nominated,
            Nominujici__r=nominating
        );
    }

    public NominationHandler setName(String name) {
        this.name = name.left(80);
        return this;
    }

    public NominationHandler setNominatingEmail(String email) {
        this.nominatingEmail = email;
        return this;
    }

    public NominationHandler setNominatedEmail(String email) {
        this.nominatedEmail = email;
        return this;
    }
}
