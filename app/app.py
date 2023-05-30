from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/validate-policy', methods=['POST'])
def validate_policy():
    # Get the data from the request
    data = request.get_json()
    # Check if the data is valid
    if not data:
        return jsonify({'message': 'No data provided'}), 400
    # Check if all the necessary fields are present
    if 'sum_assured' not in data or 'age' not in data or 'annual_income' not in data or 'otp' not in data:
        return jsonify({'message': 'Not all required data provided'}), 400
    # Check if the sum assured is within the valid range
    if data['sum_assured'] < 50000 or data['sum_assured'] > 200000:
        return jsonify({'message': 'Sum assured not in valid range'}), 400
    # Check if the age is within the valid range
    if data['age'] < 18 or data['age'] > 60:
        return jsonify({'message': 'Age not in valid range'}), 400
    # Check if the annual income is at least 40K
    if data['annual_income'] < 40000:
        return jsonify({'message': 'Annual income too low'}), 400
    # Check if the OTP is valid
    if not data['otp']:
        return jsonify({'message': 'OTP not provided'}), 400
    # All validations have passed
    return jsonify({'message': 'Validation successful'}), 200

if __name__ == '__main__':
    app.run()