// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

delete [SELECT Id FROM Log__c];
delete [SELECT Id FROM Opportunity];
delete [SELECT Id FROM Account];
delete [SELECT Id FROM Contact];
System.debug('done');

