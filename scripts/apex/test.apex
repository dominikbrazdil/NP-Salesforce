

Date fromDate = Date.newInstance(2023, 07, 26);
Date toDate = Date.newInstance(2023, 07, 26);

// AdapterraLoader.loadNominations(fromDate, toDate);
ZivaPudaLoader.loadContracts(fromDate, toDate);

// RecurrentDonorsJob.markLostRecurrentDonorsAndRenewRestoredOnes();

Logger.closeAndStore();