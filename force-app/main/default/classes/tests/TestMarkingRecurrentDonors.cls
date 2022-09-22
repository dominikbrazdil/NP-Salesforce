@isTest
public class TestMarkingRecurrentDonors {
    
    static Id jobID;
    static DarujmeTransaction tr, tr2;
    static Contact donor;

    static {

        jobID = Id.valueOf('001xa000003DIlo');
        TestUtils.initializeConfig();

        tr = TestUtils.getTransaction(123);
        tr2 = (DarujmeTransaction)TestUtils.clone(tr, DarujmeTransaction.class);
        tr2.transactionId = 11111;
        donor = tr.createContact();

        Campaign campaign = new Campaign(Name = 'testCampaign', Darujme_Id__c = tr.pledge.projectId);
        insert campaign;

        Logger.init(jobID);
    }

    @isTest static void testSuccessfulyUnmarkRecurrentDonor() {
        
        DatabaseManager.insertListPartialEnabled(new List<Contact>{donor});

        Date monthAndDayAgo = Date.today().addMonths(-1).addDays(-1);
        Dar__c dar1 = tr.createDar();
        dar1.Datum__c = monthAndDayAgo;
        dar1.Pravidelny_dar__c = true;

        Dar__c dar2 = tr2.createDar();
        dar2.Datum__c = Date.today();
        dar2.Pravidelny_dar__c = false;

        DatabaseManager.insertListPartialEnabled(new List<Dar__c>{dar1, dar2});

        Test.startTest();
        RecurrentDonorsJob.reportAndUnmarkLostRecurrentDonors();
        Logger.closeAndStore();
        Test.stopTest();

        System.debug(donor);

        Contact c = [SELECT Id, Email, Pravidelny_darce__c, Ztraceny_pravidelny_darce__c FROM Contact WHERE Email = :donor.Email_External_Id__c];
        System.assert(!c.Pravidelny_darce__c, 'Donor was not unmarked from recurrent donors');
        System.assert(c.Ztraceny_pravidelny_darce__c, 'Donor was not marked as lost recurrent donor');
        System.assertEquals(1, TestUtils.getLogs(jobID, LoggingLevel.WARN).size(), 'Unmarked donor was not logged');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    @isTest static void testDoNotUnmarkRecurrentDonorWithDonation() {
        DatabaseManager.insertListPartialEnabled(new List<Contact>{donor});

        Date monthAgo = Date.today().addMonths(-1);
        Dar__c dar = tr.createDar();
        dar.Datum__c = monthAgo;
        dar.Pravidelny_dar__c = true;

        DatabaseManager.insertListPartialEnabled(new List<Dar__c>{dar});

        Test.startTest();
        RecurrentDonorsJob.reportAndUnmarkLostRecurrentDonors();
        Logger.closeAndStore();
        Test.stopTest();

        Contact c = [SELECT Id, Email, Pravidelny_darce__c, Ztraceny_pravidelny_darce__c FROM Contact WHERE Email =:donor.Email_External_Id__c];
        System.assert(c.Pravidelny_darce__c, 'Donor was unmarked from recurrent donors');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }
}
