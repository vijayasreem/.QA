({
    doInit : function(component, event, helper) {
        // Initialize payment gateway
        component.find("paymentGateway").initialize({
            // Pass in payment gateway configuration
            config: {
                // Supported payment methods
                paymentMethods: ["credit/debit cards", "PayPal", "Stripe"],
                // Secure payment page url
                paymentPageUrl: "https://secure.paymentpage.com"
            },
            // Pass in event handlers
            handlers: {
                // Callback for successful payment
                onSuccess: function(paymentDetails) {
                    // Handle successful payment
                    helper.handleSuccessfulPayment(component, paymentDetails);
                },
                // Callback for failed payment
                onError: function(error) {
                    // Handle failed payment
                    helper.handleFailedPayment(component, error);
                }
            }
        });
    },
    // Handle form submission and initiate payment process
    handleSubmit: function(component, event, helper) {
        event.preventDefault();
        // Get form data
        let formData = event.getParam("formData");
        // Initiate payment process
        component.find("paymentGateway").process(formData);
    }
});