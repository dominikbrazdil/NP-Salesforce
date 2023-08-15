

Date fromDate = Date.newInstance(2023, 05, 23);
Date toDate = Date.newInstance(2023, 05, 23);

// AdapterraLoader.loadNominations(fromDate, toDate);
ZivaPudaLoader.loadContracts(fromDate, toDate);

// RecurrentDonorsJob.markLostRecurrentDonorsAndRenewRestoredOnes();

Logger.closeAndStore();