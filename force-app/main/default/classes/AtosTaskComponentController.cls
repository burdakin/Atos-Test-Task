public with sharing class AtosTaskComponentController {

    @AuraEnabled(cacheable=true)
    public static List<User> searchUsers(String searchValue) {
        return AtosTaskComponentHelper.searchUsers(searchValue);
}

    @AuraEnabled(cacheable=true)
    public static Boolean pushNewTask(String param){
        try {
            AtosTaskComponentHelper.insertNewTask(param);
            return true;
        } catch (Exception e) {
            System.debug(e);
            return false;
        }
    }

    @AuraEnabled (cacheable=true)
    public static List<String> getNameOfLead(String recordId){
        return AtosTaskComponentHelper.getLeadName(recordId);
    }
    
}
