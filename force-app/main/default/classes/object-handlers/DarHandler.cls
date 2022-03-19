public without sharing class DarHandler {
	
    public static Dar__c build(Contact contact, DarujmeTransaction tr) {
        Campaign campaign = new Campaign(Darujme_Id__c = tr.pledge.projectId);

        return new Dar__c(
            Name = tr.receivedAt.left(10), // YYYY-MM-DD format
            Datum__c = Date.valueOf(tr.receivedAt.left(10)),
            Darovana_castka__c = tr.sentAmount.cents / 100,
            Prijata_castka__c = tr.outgoingAmount.cents / 100,
            Transaction_Id__c = tr.transactionId,
            Pravidelny_dar__c = tr.pledge.isRecurrent,
            Kampan__r = campaign,
            Pozaduje_potvrzeni__c = tr.pledge.wantDonationCertificate,
            Darovano_na_vyzvu__c = tr.pledge.promotionId != null,
            Darce__c = contact.Id
        );
    }
    
}