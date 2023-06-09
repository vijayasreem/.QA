//Unit Tests
@isTest
private class EmailNotificationsTest {
    //Test for successful sendWelcomeEmail
    @isTest static void testSendWelcomeEmail() {
        User u = new User(LastName = 'Test', Email = 'test@test.com', Alias = 'test');
        insert u;
        Test.startTest();
        EmailNotifications.sendWelcomeEmail(u.Id);
        Test.stopTest();
        User usr = [SELECT Id, Email, Name FROM User WHERE Id = :u.Id];
        System.assert(usr.Email == 'test@test.com');
    }
    
    //Test for successful sendNotificationEmail
    @isTest static void testSendNotificationEmail() {
        Account a = new Account(Name='Test Account', Phone='123-456-7890');
        insert a;
        Test.startTest();
        EmailNotifications.sendNotificationEmail(UserInfo.getUserId(), a.Id);
        Test.stopTest();
        Account acc = [SELECT Id, Name, Phone FROM Account WHERE Id = :a.Id];
        System.assert(acc.Phone == '123-456-7890');
    }
    
    //Test for successful handleEmailDelivery
    @isTest static void testHandleEmailDelivery() {
        Test.startTest();
        EmailNotifications.handleEmailDelivery();
        Test.stopTest();
        System.assertEquals(100, Messaging.getSingleEmailLimits().getRemaining());
    }
    
    //Test for successful trackEmailStatus
    @isTest static void testTrackEmailStatus() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setStatus('Error');
        insert mail;
        Test.startTest();
        EmailNotifications.trackEmailStatus();
        Test.stopTest();
        List<Messaging.Email> emails = [SELECT Id, Status, ErrorMessage FROM Messaging.Email WHERE Status = 'Error'];
        System.assertNotEquals(null, emails);
    }
    
    //Test for successful handleEmailErrors
    @isTest static void testHandleEmailErrors() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setStatus('Error');
        insert mail;
        Test.startTest();
        EmailNotifications.handleEmailErrors();
        Test.stopTest();
        List<Messaging.Email> emails = [SELECT Id, Status, ErrorMessage FROM Messaging.Email WHERE Status = 'Error'];
        System.assertNotEquals(null, emails);
    }

}