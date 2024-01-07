

Date fromDate = Date.newInstance(2023, 12, 28);
Date toDate = Date.newInstance(2023, 12, 31);

// AdapterraLoader.loadNominations(fromDate, toDate);
ZivaPudaLoader.loadContracts(fromDate, toDate);

// RecurrentDonorsJob.markLostRecurrentDonorsAndRenewRestoredOnes();

Logger.closeAndStore();