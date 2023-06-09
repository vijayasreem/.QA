public class EmailNotifications {
    
    //Class constructor
    public EmailNotifications(){
    }
    
    //Send welcome email to new users
    public static void sendWelcomeEmail(Id userId) {
        //get user details
        User user = [SELECT Id, Email, Name FROM User WHERE Id = :userId];
        
        //create email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId('Welcome_Email_Template');
        mail.setTargetObjectId(user.Id);
        mail.setSaveAsActivity(false);
        
        //send email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //Send email notifications for important actions
    public static void sendNotificationEmail(Id userId, String action) {
        //get user details
        User user = [SELECT Id, Email, Name FROM User WHERE Id = :userId];
        
        //create email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId('Notification_Email_Template');
        mail.setTargetObjectId(user.Id);
        mail.setWhatId(action);
        mail.setSaveAsActivity(false);
        
        //send email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //Handle email delivery 
    public static void handleEmailDelivery() {
        Messaging.reserveSingleEmailCapacity(100);
        Messaging.sendEmail(Messaging.MassEmailMessage());
    }
    
    //Logging and monitoring functionality to track the status of sent emails
    public static void trackEmailStatus() {
        List<Messaging.Email> emails = [SELECT Id, Status, ErrorMessage FROM Messaging.Email WHERE Status = 'Error'];
        System.debug('Failed emails: ' + emails);
    }
    
    //Handle any delivery errors
    public static void handleEmailErrors() {
        List<Messaging.Email> emails = [SELECT Id, Status, ErrorMessage FROM Messaging.Email WHERE Status = 'Error'];
        for (Messaging.Email email : emails) {
            //do something
        }
    }
    
}