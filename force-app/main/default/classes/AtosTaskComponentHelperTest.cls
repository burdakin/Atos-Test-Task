@isTest
public with sharing class AtosTaskComponentHelperTest {
    @TestSetup
    static void makeData(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User newUser = new User();
        newUser.FirstName = 'Test';
        newUser.LastName = 'User';
        newUser.Username = 'test@testuser.it';
        newUser.Email = 'serj-b94@yandex.ru';
        newUser.LocaleSidKey = 'en_US';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.ProfileId = prof.Id;
        newUser.LanguageLocaleKey = 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.IsActive = true;
        newUser.Alias = 'NewTestU';
        newUser.Not_Started_Task__c = 0;
        newUser.In_progress_tasks__c = 0;
        insert newUser;

        Lead newLead = new Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'Lead';
        newLead.Status = 'Открыто';
        insert newLead;

    }
    
    @isTest
    public static void searchUsersTest() {
        User searchResultUser = [SELECT id, LastName, Username, Email FROM User WHERE Username = 'test@testuser.it' LIMIT 1];

        Test.startTest();
        List<User> result = AtosTaskComponentController.searchUsers(searchResultUser.Email);
        Test.stopTest();

        System.assertNotEquals(0, result.size());
    }

    @isTest
    public static void getLeadNameTest() {
        Lead testLead = [SELECT Id, FirstName, LastName FROM Lead WHERE FirstName = 'Test' LIMIT 1];

        Test.startTest();
        List<String> result = AtosTaskComponentController.getNameOfLead(testLead.id);
        Test.stopTest();

        System.assertNotEquals(0, result.size());
        System.assertEquals(2, result.size());
    }

    @isTest 
    public static void insertNewTaskTest() {
        User owner = [SELECT id, LastName, Username, Email FROM User WHERE Username = 'test@testuser.it' LIMIT 1];
        String param = '{"OwnerId":"' + owner.Id + '","Subject":"Test Task Subject Nobody Will Ever Query","Priority":"Normal","Description":"Test","FirstName":"Nice","LastName":"Guy","ActivityDate":"2072-04-12","Status":"In Progress"}';

        Test.startTest();
        AtosTaskComponentController.pushNewTask(param);
        Test.stopTest();

        Task result = [SELECT Id, Subject FROM Task WHERE Subject = 'Test Task Subject Nobody Will Ever Query'];

        System.assertNotEquals(Null, result.Id);
        System.assertEquals('Test Task Subject Nobody Will Ever Query', result.Subject);
    }
}
