@isTest
public with sharing class TaskCreaionTriggerTest {
    @TestSetup
    static void makeData(){
        User admin = [SELECT Id, Username, FirstName, LastName, Email, Not_Started_Task__c, In_progress_tasks__c FROM User WHERE Profile.PermissionsCustomizeApplication = true AND isActive = true];
        admin.In_progress_tasks__c = 0;
        admin.Not_Started_Task__c = 0;
        update admin;
    }

    @isTest
    public static void testTrigger () {
        User admin = [SELECT Id, Username, FirstName, LastName, Email, Not_Started_Task__c, In_progress_tasks__c FROM User WHERE Profile.PermissionsCustomizeApplication = true AND isActive = true];
        
        Task testTask = new Task();
        testTask.OwnerId = admin.Id;
        testTask.ActivityDate = Date.today();
        testTask.Status = 'Not Started';
        testTask.Subject = 'TestSubject';

        Test.startTest();
            insert testTask;
            testTask.Status = 'In progress';
            update testTask;
            delete testTask;
        Test.stopTest();

        admin = [SELECT Id, Username, FirstName, LastName, Email, Not_Started_Task__c, In_progress_tasks__c FROM User WHERE Profile.PermissionsCustomizeApplication = true AND isActive = true];
        System.assertEquals(0, admin.Not_Started_Task__c);
        System.assertEquals(0, admin.In_progress_tasks__c);
    }
}
