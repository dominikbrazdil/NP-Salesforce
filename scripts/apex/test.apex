


// Contact c = new Contact(email='a@gmail.com', FirstName='f4', LastName = 'l', Mesto_soukrome__c = null);
// Contact c2 = new Contact(email='a@gmail.com', FirstName='f2', LastName = 'l');
// insert c;


// Database.upsert(new List<Contact>{c}, Contact.Email);


Date fromDate = Date.today().addDays(-4);
Date toDate = Date.today().addDays(-4);
List<String> logsToFilter = new List<String>{'DUPLICATE_VALUE'};

DarujmeLoader.loadTransactions(fromDate, toDate);

Logger.closeAndStore(logsToFilter);