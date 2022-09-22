


// Contact c = new Contact(email='a@gmail.com', FirstName='f4', LastName = 'l', Mesto_soukrome__c = null);
// Contact c2 = new Contact(email='a@gmail.com', FirstName='f2', LastName = 'l');
// insert c;


// Database.upsert(new List<Contact>{c}, Contact.Email);

Logger.init('001xa000003DIlo');
ZivaPudaLoader.loadContracts(Date.today().addYears(-2), null);

// AdapterraLoader.loadNominations(Date.today().addDays(-120), null);
Logger.closeAndStore();