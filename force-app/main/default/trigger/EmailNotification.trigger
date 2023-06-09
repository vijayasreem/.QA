trigger WelcomeEmail on User (after insert) {
	List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
	
	//Iterate through the list of new users
	for (User record : Trigger.new) {
		//Check to make sure the user has a valid email address
		if (record.Email != null) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			
			//Create the email address for the recipient
			String[] toAddresses = new String[] {record.Email};
			
			//Set the email address of the sender
			mail.setReplyTo('no-reply@example.com');
			
			//Set the subject line for the email
			mail.setSubject('Welcome to the Example App!');
			
			//Set the body of the email
			String body = 'Hi ' + record.Name + ', ' + '\n\nWelcome to the Example App! We are excited to have you onboard. ' + '\n\nYou can now login to your account and start using the app. ' + '\n\nThanks, \nThe Example Team';
			
			//Set the body of the email
			mail.setPlainTextBody(body);
			
			//Send the email
			mail.setToAddresses(toAddresses);
			
			//Add the email to the list of emails to be sent
			mailList.add(mail);
		}
	}
	
	//Send the emails
	Messaging.sendEmail(mailList);
}