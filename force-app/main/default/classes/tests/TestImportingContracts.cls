
@isTest
public class TestImportingContracts {
    
    static ID jobID;
    static ZivaPudaContract contract;
    static Apex_config__c config;

    static {
        jobID = Id.valueOf('001xa000003DIlo');
        config = TestUtils.initializeConfig();

        contract = TestUtils.getContract();

        Logger.init(jobID);
    }

    @isTest static void testCallingZivaPudaEndpoint() {
        Test.setMock(HttpCalloutMock.class, new MockZivaPudaEndpoint(new List<ZivaPudaContract>{contract}));


        Test.startTest();
        ZivaPudaLoader.loadContracts(Date.today(), null);
        Logger.closeAndStore();
        Test.stopTest();


        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name IN :(new List<String>{contract.createOwnerAccount().Name})];
        System.assertEquals(1, accounts.size(), 'Account was not created');
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email_External_Id__c IN :(new List<String>{contract.Email})];
        System.assertEquals(1, contacts.size(), 'Contact was not created');
        List<Contract__c> contrs = [SELECT Id, Ziva_Puda_ID__c FROM Contract__c WHERE Ziva_Puda_ID__c = :contract.Id LIMIT 1];
        System.assertEquals(1, contrs.size(), 'Contract was not created');

        System.assert(TestUtils.getErrorLogs(jobId).isEmpty(), 'Error logs were not empty: ' + TestUtils.getErrorLogs(jobId));
    }


    @isTest static void testImportingContract() {


        Test.startTest();
        ZivaPudaLoader.importContracts(new List<ZivaPudaContract>{contract});
        Logger.closeAndStore();
        Test.stopTest();


        List<Contract__c> contrs = [SELECT 
            Id,
            Ziva_Puda_ID__c,
            Najemnik_adresa__c,
            Vlastnik_Adresa__c,	
            Dalsi_vlastnici__c,	
            Datum__c,
            Doba__c,
            Najemnik_ICO__c,
            Najemnik_jmeno__c,
            Najem__c,
            Oznamovaci_doba__c,
            PDF__c,
            Vlastnik_rok_narozeni__c,
            Sankce__c,
            Name,
            Typ__c,
            Typ_opatreni__c,
            Vlastnik__r.Email,
            Majitel_vypovedni_lhuta__c,
            Najemce_vypovedni_lhuta__c,
            Majitel_vypoved_jinak__c,
            Zavazky__c,
            Clanky__c 
            FROM Contract__c];
        System.assertEquals(1, contrs.size(), 'Contract was not created');
        Contract__c c = contrs[0];
        System.assertEquals(c.Ziva_Puda_ID__c, contract.id, 'Id did not match');
        System.assertEquals(c.Najemnik_adresa__c, contract.lessee.headquarters, 'Lessee address did not match');
        System.assertEquals(c.Vlastnik_Adresa__c, contract.owners[0].address, 'Owner address did not match');
        System.assertEquals(c.Dalsi_vlastnici__c, String.join(contract.getOwners(), '\n'), 'Owners did not match');
        System.assertEquals(c.Datum__c, Utils.parseDate(contract.signingDate, 'd.M.y h:m:s'), 'Date did not match');
        System.assertEquals(c.Doba__c, contract.leasePeriod.howLong, 'Period did not match');
        System.assertEquals(c.Najemnik_ICO__c, contract.lessee.ICO, 'ICO did not match');
        System.assertEquals(c.Najemnik_jmeno__c, contract.lessee.name, 'Lessee name did not match');
        System.assertEquals(c.Najem__c, contract.rent, 'Rent did not match');
        System.assertEquals(c.Oznamovaci_doba__c, contract.leasePeriod.noticePeriod, 'Notice period did not match');
        System.assertEquals(c.PDF__c, contract.url, 'Url did not match');
        System.assertEquals(c.Vlastnik_rok_narozeni__c, Integer.valueOf(contract.owners[0].birthdate.left(4)), 'Year did not match');
        System.assertEquals(c.Sankce__c, contract.sanctions, 'Sanctions did not match');
        System.assertEquals(c.Name, contract.owners[0].name, 'Name did not match');
        System.assertEquals(c.Typ__c, contract.leasePeriod.type, 'Type did not match');
        System.assertEquals(c.Typ_opatreni__c, contract.obligations.mandatoryMeasures.type, 'Measures type did not match');
        System.assertEquals(c.Vlastnik__r.Email, contract.email, 'Email did not match');
        System.assertEquals(c.Majitel_vypovedni_lhuta__c, contract.resignation.owner, 'Owner resignation did not match');
        System.assertEquals(c.Najemce_vypovedni_lhuta__c, contract.resignation.lessee, 'Lessee resignation did not match');
        System.assertEquals(c.Majitel_vypoved_jinak__c, contract.resignation.ownerElse, 'Owner else resignation did not match');
        System.assertEquals(c.Zavazky__c, String.join(contract.obligations.pledge, '\n'), 'Pledges resignation did not match');
        System.assertEquals(c.Clanky__c, contract.resignation.articles, 'Articles else resignation did not match');
        
        List<Ground__c> grounds = [SELECT Id, Id_parcely__c, Name, Opatreni__c, Plocha__c, Typ__c FROM Ground__c WHERE Pachtovni_Smlouva__r.Id = :c.Id];
        System.assertEquals(2, grounds.size(), 'Grounds were not created');
        Ground__c g = grounds[0];
        System.assertEquals(g.Id_parcely__c, contract.grounds[0].parcelID, 'Parcel id did not match');
        System.assertEquals(g.Name, contract.grounds[0].uzemi, 'Parcel name did not match');
        System.assertEquals(g.Opatreni__c, String.join(contract.obligations.mandatoryMeasures.measuresByGrounds[0].measures, ';'), 'Parcel measures did not match');
        System.assertEquals(g.Plocha__c, Decimal.valueOf(contract.grounds[0].area), 'Parcel area did not match');
        System.assertEquals(g.Typ__c, contract.grounds[0].type, 'Parcel type did not match');
        
    }

    @isTest static void testNotImportingDuplicateGrounds() {
      

        Test.startTest();
        
        ZivaPudaLoader.importContracts(new List<ZivaPudaContract>{contract});
        Logger.closeAndStore();
        
        List<Ground__c> grounds = [SELECT Id, Id_parcely__c FROM Ground__c WHERE Pachtovni_Smlouva__r.Ziva_Puda_ID__c = :contract.Id];
        
        System.assertEquals(2, grounds.size(), 'Grounds were not created');
        Importer.insertGrounds(contract.createGrounds());
        
        Test.stopTest();

        grounds = [SELECT Id, Id_parcely__c FROM Ground__c WHERE Pachtovni_Smlouva__r.Ziva_Puda_ID__c = :contract.Id];

        System.assertEquals(2, grounds.size(), 'Grounds number did not match expected');
    }


    private class MockZivaPudaEndpoint implements HttpCalloutMock {

        private List<ZivaPudaContract> contrs;

        public MockZivaPudaEndpoint(List<ZivaPudaContract> contracts) {
            this.contrs = contracts;
        }

        public HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            res.setBody(JSON.serialize(this.contrs));

            return res;
        }
    }
}
