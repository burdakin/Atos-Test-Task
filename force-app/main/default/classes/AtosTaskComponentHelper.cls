public with sharing class AtosTaskComponentHelper {

    public static List<User> searchUsers (String searchValue) {
        String searchString = '%' + searchValue + '%';
        List<User> result = [SELECT ID, FirstName, LastName, Email 
            FROM User 
            WHERE LastName LIKE :searchString 
            OR FirstName LIKE :searchString 
            OR Email LIKE :searchString];
        return result;
    }

    public static List<String> getLeadName (String recordId) {
        List<String> result = new List<String>();
        Lead l = [SELECT FirstName, LastName FROM Lead WHERE Id =: recordId];
        result.add(l.FirstName);
        result.add(l.LastName);
        return result;
    }

    @future
    public static void insertNewTask(String param) {
        taskWrapper res = (taskWrapper)JSON.deserialize(param, taskWrapper.class);
        Task newTask = new Task();
        newTask.Subject = res.subject;
        newTask.Status = res.status;
        newTask.Priority = res.priority;
        newTask.ActivityDate = Date.valueOf(res.activityDate);
        newTask.OwnerId = res.ownerId;
        newTask.Description = res.description;
        insert newTask;
    }

    public class taskWrapper {
        String subject;
        String description;
        String activityDate;
        String ownerId;
        String priority;
        String status;
        String firstName;
        String lastName;
    }
}
