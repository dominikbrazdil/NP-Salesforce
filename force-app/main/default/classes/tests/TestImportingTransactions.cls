@isTest
public class TestImportingTransactions {

    static DarujmeTransaction tr1, tr2, tr3;
    static DarujmePromotion pr1;
    static Account account1;
    static Contact contact1;
    static Dar__c dar1, dar2;

    static Id jobID;
    static Apex_config__c config;

    // Executed before each test,
    static {

        jobID = Id.valueOf('001xa000003DIlo');

        pr1 = TestUtils.getPromotion();
        List<DarujmeTransaction> trs = TestUtils.getClonedTransactions(3, 1);
        tr1 = trs[0];
        tr2 = trs[1];
        tr3 = trs[2];

        account1 = tr1.createAccount();
        contact1 = tr1.createContact();
        dar1 = tr1.createDar();
        dar2 = tr2.createDar();

        Campaign campaign = new Campaign(Name = 'testCampaign', Darujme_Id__c = tr1.pledge.projectId);
        insert campaign;

        config = TestUtils.config;
        insert config;

        Logger.init(jobID);
    }


    @isTest static void testCallingDarujmeEndpoint() {
        Test.setMock(HttpCalloutMock.class, new MockDarujmeEndpoint(new List<DarujmeTransaction>{tr1}, pr1));

        Test.startTest();
        DarujmeLoader.loadTransactions(Date.today(), null);
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :tr1.createAccount().Name];
        System.assertEquals(1, accounts.size(), 'Account was not created');
        List<Contact> contacts = [SELECT Id, Email, Email_External_Id__c, MobilePhone, FirstName, LastName, AccountId FROM Contact WHERE Email_External_Id__c LIKE :tr1.pledge.donor.email];
        System.assertEquals(1, contacts.size(), 'Contact was not created');
        List<Dar__c> dary = [SELECT Id, Transaction_id__c, Darce__r.Id, Darce__r.Email, Name, Datum__c, Darovana_castka__c, Prijata_castka__c, Kampan__r.Darujme_Id__c, Pozaduje_potvrzeni__c, Darovano_na_vyzvu__c, Vyzva__c FROM Dar__c WHERE Transaction_Id__c = :tr1.transactionId LIMIT 1];
        System.assert(!dary.isEmpty(), 'Dar was not created');

        Dar__c dar = dary[0];
        System.assertEquals(pr1.title.cs, dar.Vyzva__c, 'Promotion title was not set correctly on Dar');

        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }
    
    
    @isTest static void testImportNewAccountAndContact() {

        Test.startTest();
        DarujmeLoader.importTransactions(new List<DarujmeTransaction>{tr1}, new Map<Integer, DarujmePromotion>{pr1.promotionId => pr1});
        Logger.closeAndStore();
        Test.stopTest();


        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :tr1.createAccount().Name];
        System.assertEquals(1, accounts.size(), 'Account was not created');
        Account a = accounts[0];
        System.assertEquals(tr1.createAccount().Name, a.Name);

        List<Contact> contacts = [SELECT Id, Email, Email_External_Id__c, MobilePhone, FirstName, LastName, AccountId, Ulice_soukrome__c, Mesto_soukrome__c, PSC_soukrome__c FROM Contact WHERE Email_External_Id__c LIKE :tr1.pledge.donor.email];
        System.assertEquals(1, contacts.size(), 'Contact was not created');
        Contact c = contacts[0];
        System.assertEquals(a.Id, c.AccountId, 'Account was not assigned to contact');
        System.assertEquals(tr1.pledge.donor.email, c.Email);
        System.assertEquals(tr1.pledge.donor.email, c.Email_External_Id__c);
        System.assertEquals(tr1.pledge.donor.firstName, c.FirstName);
        System.assertEquals(tr1.pledge.donor.lastName, c.LastName);
        System.assertEquals(tr1.pledge.donor.phone, c.MobilePhone);
        System.assertEquals(tr1.pledge.donor.address.street, c.Ulice_soukrome__c);
        System.assertEquals(tr1.pledge.donor.address.city, c.Mesto_soukrome__c);
        System.assertEquals(tr1.pledge.donor.address.postCode, c.PSC_soukrome__c);

        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }


    @isTest static void testImportNewDar() {

        Test.startTest();
        DarujmeLoader.importTransactions(new List<DarujmeTransaction>{tr1}, new Map<Integer, DarujmePromotion>{pr1.promotionId => pr1});
        Logger.closeAndStore();
        Test.stopTest();


        List<Dar__c> dary = [SELECT Id, Transaction_id__c, Darce__r.Id, Darce__r.Email, Darce__r.Pravidelny_darce__c, Name, Datum__c, Darovana_castka__c, Prijata_castka__c, Kampan__r.Darujme_Id__c, Pozaduje_potvrzeni__c, Darovano_na_vyzvu__c, Vyzva__c FROM Dar__c WHERE Transaction_Id__c = :tr1.transactionId LIMIT 1];
        System.assert(!dary.isEmpty(), 'Dar was not created');
        Dar__c dar = dary[0];
        System.assertEquals(tr1.transactionId, dar.Transaction_Id__c);
        System.assertEquals(tr1.pledge.donor.email, dar.Darce__r.email);
        System.assertEquals(tr1.pledge.isRecurrent, dar.Darce__r.Pravidelny_darce__c);
        System.assertEquals(tr1.receivedAt.left(10), dar.Name);
        System.assertEquals(tr1.receivedAt.left(10), ((Datetime)dar.Datum__c).format('yyyy-MM-dd'));
        System.assertEquals(tr1.sentAmount.cents, dar.Darovana_castka__c * 100);
        System.assertEquals(tr1.outgoingAmount.cents, dar.Prijata_castka__c * 100);
        System.assertEquals(tr1.pledge.projectId, dar.Kampan__r.Darujme_Id__c);
        System.assertEquals(tr1.pledge.wantDonationCertificate, dar.Pozaduje_potvrzeni__c);
        System.assert(dar.Darovano_na_vyzvu__c);
        System.assertEquals(pr1.title.cs, dar.Vyzva__c);

        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    @isTest static void testImportDuplicateTransaction() {
        DarujmeLoader.importTransactions(new List<DarujmeTransaction>{tr1}, new Map<Integer, DarujmePromotion>{pr1.promotionId => pr1});
        
        Test.startTest();
        Importer.insertDary(new List<Dar__c>{tr1.createDar()});
        Logger.closeAndStore();
        Test.stopTest();


        List<Dar__c> dary = [SELECT Id, Transaction_id__c FROM Dar__c];
        System.assertEquals(1, dary.size(), 'Number of Dary created did not match');
        
        List<Log__c> logs = TestUtils.getErrorLogs(jobId);
        System.assertEquals(1, logs.size(), 'Error logs number did not match');
        System.assert(logs[0].Message__c.contains(System.StatusCode.DUPLICATE_VALUE.name()), 'Log did not contain correct error');
    }

    @isTest static void testInsertDarWithNonExistingContact() {
        
        Test.startTest();
        Importer.insertDary(new List<Dar__c>{dar1});
        Logger.closeAndStore();
        Test.stopTest();


        List<Dar__c> dary = [SELECT Id, Transaction_id__c FROM Dar__c WHERE Transaction_Id__c = :tr1.transactionId];
        System.assertEquals(0, dary.size(), 'Dar was created');
        
        List<Log__c> logs = TestUtils.getErrorLogs(jobId);
        System.assertEquals(1, logs.size(), 'Error logs number did not match');
        System.assert(logs[0].Message__c.contains(System.StatusCode.INVALID_FIELD.name()), 'Log did not contain correct error');
    }

    @isTest static void testImportTwoTransactionsToOneContact() {
        Importer.insertNonExistingContactsWithAccounts(new List<Account>{account1}, new List<Contact>{contact1});

        
        Test.startTest();
        Importer.insertDary(new List<Dar__c>{dar1, dar2});
        Test.stopTest();


        List<Dar__c> dary = [SELECT Id, Transaction_id__c, Darce__r.Id FROM Dar__c];
        System.assertEquals(2, dary.size(), 'Number of created Dary did not match');
        System.assertEquals(dary[0].Darce__r.Id, dary[1].Darce__r.Id, 'Dary had different contacts assigned');
    }

    @isTest static void testDoNotImportUnssuccessfulTransactions() {
        List<DarujmeTransaction> trs = TestUtils.getClonedTransactions(4, 1);
        trs[1].state = DarujmeTransaction.TransactionState.CANCELED;
        trs[2].state = DarujmeTransaction.TransactionState.FAILURE;
        trs[3].state = DarujmeTransaction.TransactionState.TIMEOUT;

        Integer numberOfTrsToImport = 0;
        for (DarujmeTransaction tr: trs) {
            if (DarujmeLoader.TRANSACTION_STATES_TO_IMPORT.contains(tr.state)) {
                numberOfTrsToImport += 1;
            }
        }

        Test.setMock(HttpCalloutMock.class, new MockDarujmeEndpoint(trs, pr1));
        
        Test.startTest();
        DarujmeLoader.loadTransactions(Date.today(), null);
        Logger.closeAndStore();
        Test.stopTest();


        List<Dar__c> dary = [SELECT Id, Transaction_id__c FROM Dar__c];
        System.assertEquals(numberOfTrsToImport, dary.size(), 'Number of imported transactions did not match the expected');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    @isTest static void testTryImportTransactionToNonExistingProject() {
        tr1.pledge.projectId = 123;
        
        
        Test.startTest();
        DarujmeLoader.importTransactions(new List<DarujmeTransaction>{tr1}, new Map<Integer, DarujmePromotion>{pr1.promotionId => pr1});
        Logger.closeAndStore();
        Test.stopTest();


        List<Dar__c> dary = [SELECT Id, Transaction_id__c FROM Dar__c];
        System.assert(dary.isEmpty(), 'Transaction was inserted to non-existing project');

        List<Log__c> logs = TestUtils.getErrorLogs(jobId);
        System.assertEquals(1, logs.size(), 'Error logs number did not match');
        System.assert(logs[0].Message__c.contains(System.StatusCode.INVALID_FIELD.name()), 'Log did not contain correct error');
    }

    @isTest static void testMarkingRecurrentDonors() {
        Importer.insertNonExistingContactsWithAccounts(new List<Account>{account1}, new List<Contact>{contact1});

        dar2.Pravidelny_dar__c = false;

        Contact contact = [SELECT Id, Email_External_Id__c, Pravidelny_darce__c FROM Contact WHERE Email_External_Id__c LIKE :tr1.pledge.donor.email LIMIT 1];
        System.assert(!contact.Pravidelny_darce__c, 'Contact was marked recurrent as default');


        Test.startTest();
        Importer.insertDary(new List<Dar__c>{dar1});

        contact = [SELECT Id, Email_External_Id__c, Pravidelny_darce__c FROM Contact WHERE Id=:contact.Id LIMIT 1];
        System.assert(contact.Pravidelny_darce__c, 'Contact was not marked as recurrent');

        Importer.insertDary(new List<Dar__c>{dar2});
        Logger.closeAndStore();
        Test.stopTest();


        contact = [SELECT Id, Email_External_Id__c, Pravidelny_darce__c FROM Contact WHERE Id=:contact.Id LIMIT 1];
        System.assert(contact.Pravidelny_darce__c, 'Contact was set back to not-recurrent');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }


    @isTest static void testAddingDonorsToCampaigns() {
        Importer.insertNonExistingContactsWithAccounts(new List<Account>{account1}, new List<Contact>{contact1});

        
        Test.startTest();
        Importer.insertDary(new List<Dar__c>{dar1, dar2});
        Importer.insertDary(new List<Dar__c>{tr3.createDar()});
        Logger.closeAndStore();
        Test.stopTest();


        List<CampaignMember> members = [SELECT ContactId, CampaignId FROM CampaignMember 
                                        WHERE Contact.Email_External_Id__c = :tr1.pledge.donor.email AND Campaign.Darujme_Id__c = :tr1.pledge.projectId];

        System.assertEquals(1, members.size(), 'Donor was not assigned to campaign correctly');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }


    @isTest static void testCreateOpportunityFromContactAmountRule() {
        Integer amountOfDaryLimit = 0;//(Integer)config.Lead_amount_of_donations_limit__c;

        Importer.insertNonExistingContactsWithAccounts(new List<Account>{account1}, new List<Contact>{contact1});

        dar1.Darovana_castka__c = amountOfDaryLimit-1;
        dar2.Darovana_castka__c = amountOfDaryLimit;


        Test.startTest();
        Importer.insertDary(new List<Dar__c>{dar1});
        List<Opportunity> opps = [SELECT Id, Kontaktniosoba__r.Email_External_Id__c FROM Opportunity WHERE Kontaktniosoba__r.Email_External_Id__c=:tr1.pledge.donor.email];
        System.assert(opps.isEmpty(), 'Opportunity was created despite the rule');

        Importer.insertDary(new List<Dar__c>{dar2});
        opps = [SELECT Id, Kontaktniosoba__r.Email_External_Id__c FROM Opportunity WHERE Kontaktniosoba__r.Email_External_Id__c=:tr1.pledge.donor.email];
        Logger.closeAndStore();
        Test.stopTest();


        System.assertEquals(1, opps.size(), 'Opportunity was not created');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    @isTest static void testCreateOpportunityFromContactNumberRule() {
        Integer numberOfDaryLimit = 0;//(Integer)config.Lead_number_of_donations_limit__c;

        Importer.insertNonExistingContactsWithAccounts(new List<Account>{account1}, new List<Contact>{contact1});
        dar1.Darovana_castka__c = 0;
        List<Dar__c> dary = new List<Dar__c>();
        for (Integer i = 0; i < numberOfDaryLimit-1; i++) {
            Dar__c d = dar1.clone();
            d.Transaction_Id__c = i+1000;
            dary.add(d);
        }


        Test.startTest();
        Importer.insertDary(dary);
        List<Opportunity> opps = [SELECT Id, Kontaktniosoba__r.Email_External_Id__c FROM Opportunity WHERE Kontaktniosoba__r.Email_External_Id__c=:tr1.pledge.donor.email];
        System.assert(opps.isEmpty(), 'Opportunity was created despite the rule');

        Importer.insertDary(new List<Dar__c>{dar1});
        opps = [SELECT Id, Kontaktniosoba__r.Email_External_Id__c FROM Opportunity WHERE Kontaktniosoba__r.Email_External_Id__c=:tr1.pledge.donor.email];
        Logger.closeAndStore();
        Test.stopTest();


        System.assertEquals(1, opps.size(), 'Opportunity was not created');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }




   

    private class MockDarujmeEndpoint implements HttpCalloutMock {

        private List<DarujmeTransaction> trs;
        private DarujmePromotion pr;

        public MockDarujmeEndpoint(List<DarujmeTransaction> transactions, DarujmePromotion promotion) {
            this.trs = transactions;
            this.pr = promotion;
        }

        public HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            if (req.getEndpoint().contains('transactions')) {
                res.setBody('{"transactions":'+ JSON.serialize(this.trs) +'}');
            } else if (req.getEndpoint().contains('promotion')) {
                res.setBody('{"promotion":'+ JSON.serialize(this.pr) +'}');
            }

            return res;
        }
    }
    
}
