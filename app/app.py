from flask import Flask, request, render_template
import smtplib

app = Flask(__name__)

@app.route('/send_email', methods=['POST'])
def send_email():
    # Get the data from the request
    data = request.get_json()

    # Create the email server
    server = smtplib.SMTP('smtp.example.com', 587)

    # Login to the email server
    server.login("username", "password")

    # Send the email
    server.sendmail(
        data['from'],
        data['to'],
        data['message']
    )

    # Log the status of the sent email
    app.logger.info('Email sent!')

    # Return a success message
    return "Email sent successfully!"

@app.route('/new_user/<user_id>', methods=['GET'])
def new_user(user_id):
    # Get the user data
    user = get_user_data(user_id)

    # Render the welcome email template
    message = render_template('welcome_email.html', user=user)

    # Create the email server
    server = smtplib.SMTP('smtp.example.com', 587)

    # Login to the email server
    server.login("username", "password")

    # Send the email
    server.sendmail(
        'noreply@example.com',
        user['email'],
        message
    )

    # Log the status of the sent email
    app.logger.info('Welcome email sent!')

    # Return a success message
    return "Welcome email sent successfully!"

if __name__ == '__main__':
    app.run()