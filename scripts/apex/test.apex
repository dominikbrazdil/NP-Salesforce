

Date fromDate = Date.newInstance(2023, 04, 04);
Date toDate = Date.newInstance(2023, 04, 10);

// AdapterraLoader.loadNominations(fromDate, toDate);
ZivaPudaLoader.loadContracts(fromDate, toDate);

// RecurrentDonorsJob.markLostRecurrentDonorsAndRenewRestoredOnes();

Logger.closeAndStore();