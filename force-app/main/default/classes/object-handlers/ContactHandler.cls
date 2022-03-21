public without sharing class ContactHandler {

    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String street;
    private String city;
    private String postCode;
    private String description;
    private Id accountId;

	public Contact build() {
        return new Contact(
        	FirstName = this.firstName,
            LastName = this.lastName,
            Email_External_Id__c = this.email,
            MobilePhone = this.phone,
            Ulice_soukrome__c = this.street,
            Mesto_soukrome__c = this.city,
            PSC_soukrome__c = this.postCode,
            AccountId = this.accountId,
            Description = this.description
        );
    }

    
    public static List<Contact> retrieveContactsWithEmails(List<String> contactEmailsToSearch) {
        
        List<Contact> foundList = [SELECT Id, Email_External_Id__c FROM Contact WHERE Email_External_Id__c IN :contactEmailsToSearch WITH SECURITY_ENFORCED];
        return foundList;
    }

    public ContactHandler setFirstName(String firstName) {
        this.firstName = firstName.left(20);
        return this;
    }

    public ContactHandler setLastName(String lastName) {
        this.lastName = lastName.left(20);
        return this;
    }

    public ContactHandler setEmail(String email) {
        this.email = email.toLowerCase();
        return this;
    }

    public ContactHandler setPhone(String phone) {
        this.phone = phone;
        return this;
    }

    public ContactHandler setStreet(String street) {
        this.street = street;
        return this;
    }

    public ContactHandler setCity(String city) {
        this.city = city;
        return this;
    }

    public ContactHandler setPostCode(String postCode) {
        this.postCode = postCode;
        return this;
    }

    public ContactHandler setDescription(String description) {
        this.description = description;
        return this;
    }

    public ContactHandler setAccountId(String accountId) {
        this.accountId = accountId;
        return this;
    }
}