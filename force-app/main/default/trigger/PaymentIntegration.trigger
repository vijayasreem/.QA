trigger PaymentIntegration on Order(before insert, before update) {
    for(Order o: Trigger.new) {
        //Create a list of payment methods
        List<String> paymentMethods = new List<String>{'Credit Card', 'Debit Card', 'PayPal', 'Stripe'};
        //Check if a valid payment method is selected
        if(!paymentMethods.contains(o.Payment_Method__c)) {
            o.addError('Please select a valid payment method.');
        }
        //Check if the payment is complete
        if(o.Status__c != 'Complete') {
            //Redirect the user to the payment page
            o.Payment_URL__c = '/securepayment';
        }
    }
}

//Handle successful and failed payment transactions
trigger PaymentResult on Order(after insert, after update) {
    for(Order o: Trigger.new) {
        if(o.Status__c == 'Complete') {
            //Display a success message
            System.debug('Payment success!');
        } else if(o.Status__c == 'Failed') {
            //Display a failed message
            System.debug('Payment failed!');
        }
    }
}

//Log payment-related issues
trigger PaymentLogging on Order(before insert, before update) {
    for(Order o: Trigger.new) {
        try {
            //Insert payment details into the log
            insert new Log__c(OrderId__c = o.Id, Payment_Details__c = o.Payment_Details__c);
        } catch(Exception e) {
            //Log the exception
            System.debug(e.getMessage());
        }
    }
}