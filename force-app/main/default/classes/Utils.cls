public without sharing class Utils {
    
    /**
     * Maps the list of SObjects to specific object's fields list
     */
    public static List<String> mapToString(List<SObject> objects, SObjectField field) {
        List<String> mappedValues = new List<String>();
        for (SObject o: objects){
            mappedValues.add((String)o.get(field));
        }
        return mappedValues;
    }

    public static List<SObject> mapToSObject(List<SObject> objects, SObjectField field) {
        List<SObject> mappedValues = new List<SObject>();
        for (SObject o: objects){
            if (o.getSObject(field) != null) {
                mappedValues.add(o.getSObject(field));
            }
        }
        return mappedValues;
    }

    public static List<Id> mapToId(List<SObject> objects, SObjectField field) {
        List<Id> mappedValues = new List<Id>();
        for (SObject o: objects){
            mappedValues.add((Id)o.get(field));
        }
        return mappedValues;
    }

    public static SObject find(List<SObject> objects, SObjectField fieldToFilterBy, Object filterValue) {
        for (SObject o: objects) {
            if (o.get(fieldToFilterBy) == filterValue) {
                return o;
            }
        }
        return null;
    }

}
