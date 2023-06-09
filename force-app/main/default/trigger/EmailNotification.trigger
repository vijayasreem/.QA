trigger EmailNotifications on User (after insert) {
    // Create list of new users
    List<User> newUsers = Trigger.new;
    
    // Get current user info
    User currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId()];
    
    // Create email templates
    Messaging.SingleEmailMessage welcomeEmail = new Messaging.SingleEmailMessage();
    Messaging.SingleEmailMessage resetPasswordEmail = new Messaging.SingleEmailMessage();
    Messaging.SingleEmailMessage orderConfirmationEmail = new Messaging.SingleEmailMessage();
    Messaging.SingleEmailMessage accountActivityAlertEmail = new Messaging.SingleEmailMessage();
    
    // Set up email templates
    welcomeEmail.setTemplateId('00X1a0000008vN4');
    resetPasswordEmail.setTemplateId('00X1a0000008vN5');
    orderConfirmationEmail.setTemplateId('00X1a0000008vN6');
    accountActivityAlertEmail.setTemplateId('00X1a0000008vN7');
    
    // Create list to hold all emails
    List<Messaging.SingleEmailMessage> allEmails = new List<Messaging.SingleEmailMessage>();
    
    // Loop through new users
    for (User newUser: newUsers) {
        // Set up email recipients
        String[] toAddresses = new String[] {newUser.Email};
        welcomeEmail.setToAddresses(toAddresses);
        resetPasswordEmail.setToAddresses(toAddresses);
        orderConfirmationEmail.setToAddresses(toAddresses);
        accountActivityAlertEmail.setToAddresses(toAddresses);
        
        // Add emails to list of all emails
        allEmails.add(welcomeEmail);
        allEmails.add(resetPasswordEmail);
        allEmails.add(orderConfirmationEmail);
        allEmails.add(accountActivityAlertEmail);
    }
    
    // Send emails
    Messaging.SendEmailResult[] emailResults = 
        Messaging.sendEmail(allEmails, false);
    
    // Log and monitor email results
    for (Integer i = 0; i < emailResults.size(); i++) {
        if (emailResults[i].isSuccess()) {
            System.debug('The email was sent successfully to ' + 
            emailResults[i].getTargetObjectId());
        } else {
            // Handle errors
            Messaging.SendEmailError[] errors = emailResults[i].getErrors();
            for (Integer j = 0; j < errors.size(); j++) {
                System.debug('The following error has occurred: ' + 
                errors[j].getMessage());
            }
        }
    }
}