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

    // public static Set<Object> setMap(List<SObject> objects, SObjectField field) {
    //     Set<Object> fields = new Set<Object>();
    //     for (SObject o: objects){
    //         fields.add(o.get(field));
    //     }
    //     return fields;
    // }
}
