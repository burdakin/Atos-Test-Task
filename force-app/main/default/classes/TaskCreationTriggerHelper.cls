public with sharing class TaskCreationTriggerHelper {
    public static void taskCreation(List<Task> oldTrigger, List<Task> newTrigger, Map<Id,Task> oldTriggerMap) {
        
        List<User> result = new List<User>();
        List<Id> idsOfUser = new List<Id>();
        Map<Id,User> mapOfUsers = new Map<Id, User>();

        for (Task ts : newTrigger) {
            idsOfUser.add(ts.OwnerId);
        }
        
        //переписать заполнение мапы красивенько
        for (User u : [SELECT Id, Username, FirstName, LastName, Email, Not_Started_Task__c, In_progress_tasks__c FROM User WHERE Id in: idsOfUser]) {
            mapOfUsers.put(u.id, u);
        }
    
        for (Task ts : newTrigger) {
            
            User currentUser = mapOfUsers.get(ts.OwnerId);
    
            if(oldTrigger != Null) {
    
                Task oldTask = oldTriggerMap.get(ts.Id);
    
                if (oldTask.Status != 'Not Started' && oldTask.Status != 'In Progress' && ts.Status == 'Not Started') {
                    currentUser.Not_Started_Task__c++;
                } else if (oldTask.Status == 'Not Started' && ts.Status == 'Completed') {
                    currentUser.Not_Started_Task__c--;
                }else if (oldTask.Status == 'Not Started' && ts.Status == 'In Progress') {
                    currentUser.Not_Started_Task__c--;
                    currentUser.In_progress_tasks__c++;
                } else if (oldTask.Status == 'In Progress' && ts.Status == 'Completed') {
                    currentUser.In_progress_tasks__c--;
                }
                
            } else if (oldTrigger == Null) {
                if (ts.Status == 'Not Started') {
                    currentUser.Not_Started_Task__c++;
                } else if (ts.Status == 'In Progress') {
                    currentUser.In_progress_tasks__c++;
                }
            }

            result.add(currentUser);
        }

        update result;
    }
}
