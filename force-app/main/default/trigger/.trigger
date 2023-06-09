trigger WelcomeEmail on User (after Insert) {
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    List<String> toAddresses = new List<String>();
    //Filter the newly created users
    for(User u : Trigger.new){
        //Check if the user is created for the first time
        if(u.Is_New__c == true) {
            //Create an email template
            Messaging.EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Welcome_Email'];
            //Create an email message
            Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
            //Add the template
            mail.setTemplateId(et.Id);
            //Set the target object
            mail.setTargetObjectId(u.Id);
            //Set the relatedTo object
            mail.setWhatId(u.Id);
            //Add the address
            toAddresses.add(u.Email);
            mail.setToAddresses(toAddresses);
            //Add the email to the list
            mails.add(mail);
        }
    }
    //Send the emails
    if(!mails.isEmpty()) {
        Messaging.sendEmail(mails);
    }
}