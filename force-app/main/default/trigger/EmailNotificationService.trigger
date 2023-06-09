trigger EmailNotificationTrigger on User (after insert) {
    // Create a list of users who triggered the trigger
    List<User> users = Trigger.new;
    // Create an Email Template
    EmailTemplate template = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE Name = 'Welcome Email'];
    // Create a list to store emails
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    // Iterate through users to send emails
    for (User user : users) {
        // Create email message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Set the template to be used
        email.setTemplateId(template.Id);
        // Set recipient
        email.setTargetObjectId(user.Id);
        // Set other email properties
        email.setSaveAsActivity(true);
        // Add email to emails list
        emails.add(email);
    }
    // Send emails
    Messaging.sendEmail(emails);
    // Log the emails sent
    System.debug('Emails sent: ' + emails);
}