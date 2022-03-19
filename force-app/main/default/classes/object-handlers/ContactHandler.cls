public without sharing class ContactHandler {

	public static Contact build(DarujmeTransaction tr, Id accountId) {
        return new Contact(
        	FirstName = tr.pledge.donor.firstName.left(20),
            LastName = tr.pledge.donor.lastName.left(20),
            Email = tr.pledge.donor.email.toLowerCase(),
            MobilePhone = tr.pledge.donor.phone,
            Ulice_soukrome__c = tr.pledge.donor.address.street,
            Mesto_soukrome__c = tr.pledge.donor.address.city,
            PSC_soukrome__c = tr.pledge.donor.address.postCode,
            AccountId = accountId,
            Description = 'Created from Darujme.cz import'
        );
    }
    
    public static List<Contact> retrieveContactsWithEmails(Set<String> contactEmailsToSearch) {
        List<String> searchStrings = new List<String>();
        for (String email: contactEmailsToSearch) {
            searchStrings.add('%'+email+'%');
        }
        
        List<Contact> foundList = [SELECT Id, Email FROM Contact WHERE Email LIKE :searchStrings WITH SECURITY_ENFORCED];
        return foundList;
    }
}