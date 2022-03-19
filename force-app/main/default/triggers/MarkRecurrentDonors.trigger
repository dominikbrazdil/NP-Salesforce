
/**
* Marks contact as recurrent donor if the transactions was part of recurrent pledge
 */
trigger MarkRecurrentDonors on Dar__c (after insert) {
    Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();

    List<Dar__c> insertedDaryWithContact = new List<Dar__c>(
        [SELECT Id, Darovana_castka__c, Pravidelny_dar__c, darce__c FROM Dar__c WHERE Id IN :Trigger.New]);

    for (Dar__c dar: insertedDaryWithContact) {
        if (dar.Pravidelny_dar__c && !contactsToUpdate.containsKey(dar.darce__c)) {
            contactsToUpdate.put(dar.darce__c, new Contact(
                Id = dar.darce__c,
                Pravidelny_darce__c = true,
                Prislibena_castka__c = dar.Darovana_castka__c
            ));
        }
    }

    update contactsToUpdate.values();
}