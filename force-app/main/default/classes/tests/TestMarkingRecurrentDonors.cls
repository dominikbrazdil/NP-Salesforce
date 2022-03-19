@isTest
public class TestMarkingRecurrentDonors {
    
    static Campaign campaign;
    static Id jobID;

    static {

        jobID = Id.valueOf('001xa000003DIlo');

        campaign = new Campaign(Name = 'testCampaign', Darujme_Id__c = 1234);
        insert campaign;

        Logger.init(jobID);
    }

    @isTest static void testSuccessfulyUnmarkRecurrentDonor() {
        Contact donor = new Contact(email = 'test01@test.ie', LastName = 'Novak');
        insert donor;

        Date monthAndDayAgo = Date.today().addMonths(-1).addDays(-1);
        insert new Dar__c(Darovana_castka__c = 100, Datum__c = monthAndDayAgo, Pravidelny_dar__c = true, Darce__c = donor.Id, Kampan__c = campaign.Id);
        insert new Dar__c(Darovana_castka__c = 200, Datum__c = Date.today(), Pravidelny_dar__c = false, Darce__c = donor.Id, Kampan__c = campaign.Id);

        Test.startTest();
        RecurrentDonorsJob.reportAndUnmarkLostRecurrentDonors();
        Logger.closeAndStore();
        Test.stopTest();

        Contact c = [SELECT Id, Email, Pravidelny_darce__c, Ztraceny_pravidelny_darce__c FROM Contact WHERE Email =:donor.Email LIMIT 1];
        System.assert(!c.Pravidelny_darce__c, 'Donor was not unmarked from recurrent donors');
        System.assert(c.Ztraceny_pravidelny_darce__c, 'Donor was not marked as lost recurrent donor');
        System.assertEquals(1, TestUtils.getLogs(jobID, LoggingLevel.WARN).size(), 'Unmarked donor was not logged');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    @isTest static void testDoNotUnmarkRecurrentDonorWithDonation() {
        Contact donor = new Contact(email = 'test01@test.ie', LastName = 'Novak');
        insert donor;

        Date monthAgo = Date.today().addMonths(-1);
        insert new Dar__c(Darovana_castka__c = 100, Datum__c = monthAgo, Pravidelny_dar__c = true, Darce__c = donor.Id, Kampan__c = campaign.Id);

        Test.startTest();
        RecurrentDonorsJob.reportAndUnmarkLostRecurrentDonors();
        Logger.closeAndStore();
        Test.stopTest();

        Contact c = [SELECT Id, Email, Pravidelny_darce__c, Ztraceny_pravidelny_darce__c FROM Contact WHERE Email =:donor.Email LIMIT 1];
        System.assert(c.Pravidelny_darce__c, 'Donor was unmarked from recurrent donors');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }
}
