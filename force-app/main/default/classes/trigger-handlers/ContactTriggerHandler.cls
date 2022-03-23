public class ContactTriggerHandler {
    
    public static void createOpportunitiesFromReamrkableDonors(List<Contact> donors) {
        Integer numberOfDaryLimit = (Integer)Apex_config__c.getInstance().Lead_number_of_donations_limit__c;
        Integer amountOfDaryLimit = (Integer)Apex_config__c.getInstance().Lead_amount_of_donations_limit__c;
        
        List<Opportunity> oppsToAdd = new List<Opportunity>();

        for (Contact c: [SELECT Id, Email, FirstName, LastName, AccountId, Dary_suma__c, Celkovy_pocet_daru__c, (SELECT Id FROM Prilezitosti__r) FROM Contact WHERE Id IN :donors]) {
            if ((c.Dary_suma__c >= amountOfDaryLimit || c.Celkovy_pocet_daru__c >= numberOfDaryLimit)
                & c.Prilezitosti__r.isEmpty()) {
                oppsToAdd.add(new Opportunity(
                    Name = c.FirstName + ' ' + c.LastName,
                    Kontaktniosoba__c = c.Id,
                    AccountId = c.AccountId,
                    CloseDate = Date.today().addYears(1),
                    StageName = 'Příležitost'
                ));
            }
        }

        DatabaseManager.insertListPartialEnabled(oppsToAdd);
    }
}
