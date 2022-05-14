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

    public static final Id LARGE_DONORS_CAMPAIGN_ID = Id.valueOf(Apex_config__c.getInstance().Large_donors_campaign_id__c);
    public static final Id MEDIUM_DONORS_CAMPAIGN_ID = Id.valueOf(Apex_config__c.getInstance().Medium_donors_campaign_id__c);
    public static final Id SMALL_DONORS_CAMPAIGN_ID = Id.valueOf(Apex_config__c.getInstance().Small_donors_campaign_id__c);
    public static final Id RECURRENT_DONORS_CAMPAIGN_ID = Id.valueOf(Apex_config__c.getInstance().Recurrent_donors_campaign_id__c);
    public static final Decimal LARGE_DONORS_AMOUNT_OF_DONATIONS_LIMIT = (Decimal)Apex_config__c.getInstance().Large_donor_amount_of_donations_limit__c;
    public static final Decimal MEDIUM_DONORS_AMOUNT_OF_DONATIONS_LIMIT = (Decimal)Apex_config__c.getInstance().Medium_donor_amount_of_donations_limit__c;

    
    public static List<Contact> retrieveContactsWithEmails(List<String> contactEmailsToSearch) {
        
        List<Contact> foundList = [SELECT Id, Email_External_Id__c FROM Contact WHERE Email_External_Id__c IN :contactEmailsToSearch WITH SECURITY_ENFORCED];
        return foundList;
    }

    /**
     * Decides which campaign should be contact assigned to based on his donations and predefined limits
     */
    public static List<Id>  getRelevantDonorCampaignIds(Contact donor) {
        List<Id> campaignIds = new List<Id>();

        if (0 < donor.Dary_suma__c && donor.Dary_suma__c < MEDIUM_DONORS_AMOUNT_OF_DONATIONS_LIMIT) {
            campaignIds.add(SMALL_DONORS_CAMPAIGN_ID);
        }

        if (MEDIUM_DONORS_AMOUNT_OF_DONATIONS_LIMIT <= donor.Dary_suma__c && donor.Dary_suma__c < LARGE_DONORS_AMOUNT_OF_DONATIONS_LIMIT) {
            campaignIds.add(MEDIUM_DONORS_CAMPAIGN_ID);
        }

        if (LARGE_DONORS_AMOUNT_OF_DONATIONS_LIMIT <= donor.Dary_suma__c) {
            campaignIds.add(LARGE_DONORS_CAMPAIGN_ID);
        } 

        if (donor.Pravidelny_darce__c) {
            campaignIds.add(RECURRENT_DONORS_CAMPAIGN_ID);
        }

        return campaignIds;
    }

    public ContactHandler setFirstName(String firstName) {
        if (!String.isEmpty(firstName)) {
            this.firstName = firstName.left(20);
        }
        return this;
    }

    public ContactHandler setLastName(String lastName) {
        if (!String.isEmpty(lastName)) {
            this.lastName = lastName.left(20);
        }
        return this;
    }

    public ContactHandler setEmail(String email) {
        if (!String.isEmpty(email)) {
            this.email = email.toLowerCase();
        }
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