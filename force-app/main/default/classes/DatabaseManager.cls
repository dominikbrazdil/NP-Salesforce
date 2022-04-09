public class DatabaseManager {
   
    public static void insertListPartialEnabled(List<SObject> objects) {
        if (!objects.isEmpty()) {
            Database.SaveResult[] srList = Database.insert(objects,false);

            List<SObject> detectedDuplicates = new List<SObject>();
            Integer successful = 0;

            for (Integer i = 0; i < objects.size(); i++) {
                if (!srList[i].isSuccess()) {
                    for(Database.Error err : srList[i].getErrors()) {
                        if (err.getStatusCode() == StatusCode.DUPLICATES_DETECTED) {
                            Logger.reportDuplicateRule(objects[i], (Database.DuplicateError)err);
                            detectedDuplicates.add(objects[i]);
                        } else {
                            Logger.log(LoggingLevel.ERROR, err.getStatusCode() + ': ' + err.getMessage() + ' Inserted entity: ' + objects[i]);
                        }
                    }     
                } else {
                    successful += 1;
                }
            }

            successful += insertDetectedDuplicates(detectedDuplicates);
            
            Logger.log('Successfuly inserted ' + successful + ' out of ' + objects.size() + ' ' + objects.getSObjectType());
        }
    }


    public static void updateListPartialEnabled(List<SObject> objects) {
        if (!objects.isEmpty()) {
            Database.SaveResult[] srList = Database.update(objects,false);

            Integer successful = 0;

            for (Integer i = 0; i < objects.size(); i++) {
                if (!srList[i].isSuccess()) {
                    for(Database.Error err : srList[i].getErrors()) {
                        Logger.log(LoggingLevel.ERROR, err.getStatusCode() + ': ' + err.getMessage() + ' Inserted entity: ' + objects[i]);
                    }
                } else {
                    successful += 1;
                }
            }

            Logger.log('Successfuly updated ' + successful + ' out of ' + objects.size() + ' ' + objects.getSObjectType());
        }
    }

    public static void deleteListPartialEnabled(List<SObject> objects) {
        if (!objects.isEmpty()) {
            Database.DeleteResult[] srList = Database.delete(objects,false);

            Integer successful = 0;

            for (Integer i = 0; i < objects.size(); i++) {
                if (!srList[i].isSuccess()) {
                    for(Database.Error err : srList[i].getErrors()) {
                        Logger.log(LoggingLevel.ERROR, err.getStatusCode() + ': ' + err.getMessage() + ' Inserted entity: ' + objects[i]);
                    }
                } else {
                    successful += 1;
                }
            }

            Logger.log('Successfuly deleted ' + successful + ' out of ' + objects.size() + ' ' + objects.getSObjectType());
        }
    }


    private static Integer insertDetectedDuplicates(List<SObject> detectedDuplicates) {
        Integer successful = 0;

        if (!detectedDuplicates.isEmpty()) {
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            dml.OptAllOrNone = false;
            Database.SaveResult[] srList = Database.insert(detectedDuplicates, dml);

            for (Integer i = 0; i < detectedDuplicates.size(); i++) {
                if (!srList[i].isSuccess()) {

                    for(Database.Error err : srList[i].getErrors()) {
                        Logger.log(LoggingLevel.ERROR, err.getStatusCode() + ': ' + err.getMessage() + ' Inserted entity: ' + detectedDuplicates[i]);
                    }
                    
                } else {
                    successful += 1;
                }
            }
        }
        return successful;
    }
}
