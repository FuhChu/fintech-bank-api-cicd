from flask import Flask, jsonify, request
import uuid

app = Flask(__name__)

# In-memory 'database'
accounts = {}

@app.route("/", methods=["GET"])
def index():
    return jsonify({"message": "Welcome to the FinTech Bank API"}), 200


@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "ok"}), 200

@app.route("/accounts", methods=["POST"])
def create_account():
    data = request.get_json()
    account_id = str(uuid.uuid4())
    accounts[account_id] = {
        "name": data.get("name"),
        "balance": 0.0
    }
    return jsonify({"account_id": account_id}), 201

@app.route("/accounts/<account_id>/balance", methods=["GET"])
def get_balance(account_id):
    account = accounts.get(account_id)
    if not account:
        return jsonify({"error": "Account not found"}), 404
    return jsonify({"balance": account["balance"]}), 200

@app.route("/accounts/<account_id>/transactions", methods=["POST"])
def make_transaction(account_id):
    data = request.get_json()
    amount = data.get("amount")
    if account_id not in accounts:
        return jsonify({"error": "Account not found"}), 404
    if not isinstance(amount, (int, float)):
        return jsonify({"error": "Invalid amount"}), 400
    accounts[account_id]["balance"] += amount
    return jsonify({"new_balance": accounts[account_id]["balance"]}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
