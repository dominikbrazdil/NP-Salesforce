@isTest
public class TestImportingNominations {

    static Nomination nom1, nom2, nom3;
    static Account nominatingAccount, nominatedAccount;
    static Contact nominatingContact, nominatedContact;
    static Nominace__c n1, n2;
    static Campaign campaign;

    static ID jobID;
    static Apex_config__c config;
    
    static {
        jobID = Id.valueOf('001xa000003DIlo');
        config = TestUtils.initializeConfig();

        List<Nomination> noms = TestUtils.getClonedNominations(3, 1);
        nom1 = noms[0];
        nom2 = noms[1];
        nom3 = noms[2];

        nominatingAccount = nom1.createNominatingAccount();
        nominatingContact = nom1.createNominatingContact();
        nominatedAccount = nom1.createNominatedAccount();
        nominatedContact = nom1.createNominatedContact();
        n1 = nom1.createNomination();
        n2 = nom2.createNomination();

        Program__c program = new Program__c(Name = 'Adapterra', NP_ID__c = config.Adapterra_Program_ID__c);
        insert program;
        campaign = new Campaign(Name = 'Adapterra', StartDate = Date.today(), Program__c = program.Id);
        insert campaign;

        Logger.init(jobID);
    }

    @isTest static void testCallingAdapterraEndpoint() {
        Test.setMock(HttpCalloutMock.class, new MockKenticoEndpoint(new List<Nomination>{nom1}));


        Test.startTest();
        AdapterraLoader.loadNominations(Date.today(), null);
        Logger.closeAndStore();
        Test.stopTest();


        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name IN :(new List<String>{nom1.createNominatingAccount().Name, nom1.createNominatedAccount().Name})];
        System.assertEquals(2, accounts.size(), 'Accounts were not created');
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email_External_Id__c IN :(new List<String>{nom1.Nominating.Email, nom1.contact.contaktPerson.Email})];
        System.assertEquals(2, contacts.size(), 'Contacts were not created');
        List<Nominace__c> noms = [SELECT Id, External_Id__c FROM Nominace__c WHERE External_Id__c = :nom1.Id LIMIT 1];
        System.assertEquals(1, noms.size(), 'Nomination was not created');

        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    @isTest static void testImportingNominationWithEqualNominatingAndNominated() {
        nom1.nominating.email = nom1.contact.contaktPerson.email;


        Test.startTest();
        AdapterraLoader.ImportNominations(new List<Nomination>{nom1});
        Logger.closeAndStore();
        Test.stopTest();


        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name IN :(new List<String>{nom1.createNominatingAccount().Name, nom1.createNominatedAccount().Name})];
        System.assertEquals(1, accounts.size(), 'Two Accounts were created');
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email_External_Id__c IN :(new List<String>{nom1.Nominating.Email, nom1.contact.contaktPerson.Email})];
        System.assertEquals(1, contacts.size(), 'Two Contacts were created');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }


    @isTest static void testImportingNomination() {


        Test.startTest();
        AdapterraLoader.ImportNominations(new List<Nomination>{nom1});
        Logger.closeAndStore();
        Test.stopTest();


        List<Nominace__c> noms = [SELECT Id, Name, External_Id__c, Kategorie__c, Nominujici__r.Email, Nominovany__r.Email, Zamereni__c FROM Nominace__c ];
        System.assertEquals(1, noms.size(), 'Nomination was not created');
        Nominace__c nom = noms[0];
        System.assertEquals(nom1.id, nom.External_Id__c, 'Id did not match');
        System.assertEquals(nom1.createNomination().Kategorie__c, nom.Kategorie__c, 'Id did not match');
        System.assertEquals(nom1.name, nom.Name, 'Name did not match');
        System.assertEquals(nom1.createNomination().Zamereni__c, nom.Zamereni__c, 'Zamereni did not match');
        System.assertEquals(nom1.nominating.email, nom.Nominujici__r.Email, 'Nominating did not match');
        System.assertEquals(nom1.contact.contaktPerson.email, nom.Nominovany__r.Email, 'Nominated did not match');
    }
    
    @isTest static void testAddingNominatedToCampaigns() {

        
        Test.startTest();
        AdapterraLoader.importNominations(new List<Nomination>{nom1});
        Logger.closeAndStore();
        Test.stopTest();


        List<CampaignMember> members = [SELECT ContactId, CampaignId, Campaign.Name FROM CampaignMember 
                                        WHERE Contact.Email_External_Id__c = :nom1.contact.contaktPerson.email];

        System.assertEquals(1, members.size(), 'Nominated was not added to campaign');
        System.assertEquals(members[0].Campaign.name, campaign.Name, 'Nominated was added to wrong campaign');
        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }

    private class MockKenticoEndpoint implements HttpCalloutMock {

        private List<Nomination> noms;

        public MockKenticoEndpoint(List<Nomination> nominations) {
            this.noms = nominations;
        }

        public HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            res.setBody(JSON.serialize(this.noms));

            return res;
        }
    }
}
