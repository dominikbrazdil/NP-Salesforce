public without sharing class ZivaPudaLoader {
    
    private static ZivaPudaFetcher fetcher = new ZivaPudaFetcher();

    public static void loadContracts(Date fromDate, Date toDate) {
        Logger.log('Importing contracts from Ziva Puda from ' + fromDate.format() + ' to ' + (toDate == null ? System.today().format() : toDate.format()));
        
        List<ZivaPudaContract> contracts = fetcher.getContracts(fromDate, toDate);
        
        Logger.log(contracts.size() + ' Contracts to be inserted: ' + contracts);

        importContracts(contracts);
    }

    @TestVisible
    private static void importContracts(List<ZivaPudaContract> contracts) {
        Importer.insertNonExistingContactsWithAccounts(mapToAccounts(contracts), mapToContacts(contracts));
        Importer.insertContracts(mapToContracts(contracts));
        Importer.insertGrounds(mapToGrounds(contracts));
    }

    private static List<Account> mapToAccounts(List<ZivaPudaContract> contracts) {
        List<Account> acs = new List<Account>();

        for (ZivaPudaContract c: contracts) {
            acs.add(c.createOwnerAccount());
        }
        return acs;
    }

    private static List<Contact> mapToContacts(List<ZivaPudaContract> contracts) {
        List<Contact> contats = new List<Contact>();

        for (ZivaPudaContract c: contracts) {
            contats.add(c.createOwnerContact());
        }
        return contats;
    }

    private static List<Contract__c> mapToContracts(List<ZivaPudaContract> contracts) {
        List<Contract__c> contractsNew = new List<Contract__c>();

        for (ZivaPudaContract c: contracts) {
            contractsNew.add(c.createContract());
        }
        return contractsNew;
    }

    private static List<Ground__c> mapToGrounds(List<ZivaPudaContract> contracts) {
        List<Ground__c> grounds = new List<Ground__c>();

        for (ZivaPudaContract c: contracts) {
            grounds.addAll(c.createGrounds());
        }
        return grounds;
    }
}
