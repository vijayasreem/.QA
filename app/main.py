# Fast API
@app.route("/payment", methods=["GET", "POST"])
def payment():
    if request.method == "GET":
        # Return the payment page for the user to enter their payment details.
    elif request.method == "POST":
        # Get the payment details entered by the user.
        payment_details = request.get_json()

        # Validate the payment details.
        if not validate_payment_details(payment_details):
            return jsonify({"error": "Invalid payment details"})

        # Process the payment using the payment gateway.
        payment_status = process_payment(payment_details)

        # Handle the payment status.
        if payment_status == "success":
            # Redirect the user to a success page.
            return redirect(url_for("payment_success"))
        elif payment_status == "failed":
            # Redirect the user to a failed page.
            return redirect(url_for("payment_failed"))
        else:
            # Log the payment status for debugging purposes.
            log_payment_status(payment_status)
            return jsonify({"error": "An error occurred"})