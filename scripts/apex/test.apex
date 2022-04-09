


// Contact c = new Contact(email='a@gmail.com', FirstName='f4', LastName = 'l', Mesto_soukrome__c = null);
// Contact c2 = new Contact(email='a@gmail.com', FirstName='f2', LastName = 'l');

// Database.upsert(new List<Contact>{c}, Contact.Email);

Logger.init('001xa000003DIlo');
DarujmeLoader.loadTransactions(Date.today().addDays(-10),null);

// AdapterraLoader.loadNominations(Date.today().addDays(-15), null);
Logger.closeAndStore();