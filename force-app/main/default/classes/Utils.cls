public without sharing class Utils {
    
    /**
     * Maps the list of SObjects to specific object's String fields list
     */
    public static List<String> mapToString(List<SObject> objects, SObjectField field) {
        List<String> mappedValues = new List<String>();
        for (SObject o: objects){
            mappedValues.add((String)o.get(field));
        }
        return mappedValues;
    }

    /**
     * Maps the list of SObjects to list of SObjects mapped to them
     */
    public static List<SObject> mapToSObject(List<SObject> objects, SObjectField field) {
        List<SObject> mappedValues = new List<SObject>();
        for (SObject o: objects){
            if (o.getSObject(field) != null) {
                mappedValues.add(o.getSObject(field));
            }
        }
        return mappedValues;
    }

    /**
     * Maps the list of SObjects to specific object's ID fields list
     */
    public static List<Id> mapToId(List<SObject> objects, SObjectField field) {
        List<Id> mappedValues = new List<Id>();
        for (SObject o: objects){
            mappedValues.add((Id)o.get(field));
        }
        return mappedValues;
    }

    /**
     * Maps the list of SObjects to specific object's Decimal fields list
     */
    public static List<Decimal> mapToDecimal(List<SObject> objects, SObjectField field) {
        List<Decimal> mappedValues = new List<Decimal>();
        for (SObject o: objects){
            mappedValues.add((Decimal)o.get(field));
        }
        return mappedValues;
    }

    /**
     * Finds one object in the list of SObjects with specific filed containing given value
     */
    public static SObject find(List<SObject> objects, SObjectField fieldToFilterBy, Object filterValue) {
        for (SObject o: objects) {
            if (o.get(fieldToFilterBy) == filterValue) {
                return o;
            }
        }
        return null;
    }

    /**
     * Parses date from string format to Date object
     * Assumes 4-digit year, 2-digit months and days
     * format - y, M, d values separated by same separator, e.g. 'y.M.d' or 'd-Y-M'
     */
    public static Date parseDate(String dateString, String format) {
        String separator = format.substring(1, 2);
        List<String> codes = format.split('\\'+separator);
        List<String> parts = dateString.split('\\'+separator);

        Integer years, months, days;

        for(Integer i = 0; i < codes.size(); i++) {
            String datePart = parts[i];
            switch on codes[i] {
                when 'y' {
                    years = Integer.valueOf(datePart.left(4));
                }
                when 'M' {
                    months = Integer.valueOf(datePart.left(2));
                }
                when 'd' {
                    days = Integer.valueOf(datePart.left(2));
                }
                when else {
                    return null;
                }
            }
        }

        return Date.newInstance(years, months, days);
    }

}
