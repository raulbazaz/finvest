import requests
from flask import Flask, request, jsonify
from flask_cors import CORS
import csv
from datetime import datetime
import os

app = Flask(__name__)
CORS(app)

STOCK_API_URL = "http://127.0.0.1:5002"  # URL of the stock API
BUDGET_API_URL = "http://127.0.0.1:5002"  # URL of the main API (app.py)
GOALS_FILE_PATH = "goals.csv"  # Path to the CSV file for storing goals

def fetch_monthly_budget():
    """Fetch the monthly budget from the main API (app.py)."""
    try:
        response = requests.get(f"{BUDGET_API_URL}/summary")
        if response.status_code == 200:
            data = response.json()
            return data.get("remaining_budget", 0)  # Use remaining budget as the monthly budget
        else:
            return 0
    except Exception as e:
        print(f"Error fetching budget: {e}")
        return 0

def save_goal_to_csv(goal_data):
    """Save the goal data to a CSV file."""
    file_exists = os.path.isfile(GOALS_FILE_PATH)
    with open(GOALS_FILE_PATH, mode="a", newline="") as file:
        writer = csv.writer(file)
        if not file_exists:
            # Write header if the file doesn't exist
            writer.writerow([
                "Timestamp", "goal", "goal_amount", "months", "monthly_budget",
                "required_monthly_savings", "remaining_budget"
            ])
        # Write the goal data
        writer.writerow([
            datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            goal_data["goal"],
            goal_data["goal_amount"],
            goal_data["months"],
            goal_data["monthly_budget"],
            goal_data["required_monthly_savings"],
            goal_data["remaining_budget"]
        ])

def read_goals_from_csv():
    """Read all goals from the CSV file."""
    goals = []
    if os.path.isfile(GOALS_FILE_PATH):
        with open(GOALS_FILE_PATH, mode="r") as file:
            reader = csv.DictReader(file)
            for row in reader:
                goals.append(row)
    else:
        print("goals.csv not found")
    return goals

@app.route("/set-goal", methods=["POST"])
def set_goal():
    data = request.json
    goal_name = data.get("goal")
    goal_amount = float(data.get("amount", 0))
    months = int(data.get("months", 1))

    if not goal_name or goal_amount <= 0 or months <= 0:
        return jsonify({"error": "Invalid goal details"}), 400

    # Fetch the monthly budget from app.py
    monthly_budget = fetch_monthly_budget()
    if monthly_budget <= 0:
        return jsonify({"error": "Invalid or missing monthly budget"}), 400

    # Calculate required monthly savings
    required_monthly_savings = goal_amount / months

    # Calculate remaining budget after savings
    remaining_budget = monthly_budget - required_monthly_savings

    if remaining_budget < 0:
        return jsonify({"error": "Goal cannot be achieved with the current budget"}), 400

    # Fetch stock trends from the stock API
    stock_response = requests.post(f"{STOCK_API_URL}/investment-suggestions", json={"tickers": ['AAPL', 'GOOGL', 'MSFT','RBLX','PINS','FTNT','NET','TTWO','EXPE','NKE','GPRO']})
    if stock_response.status_code != 200:
        return jsonify({"error": "Could not fetch stock market trends"}), 500

    stock_trends = stock_response.json()

    # Prepare goal data to save
    goal_data = {
        "goal": goal_name,
        "goal_amount": goal_amount,
        "months": months,
        "monthly_budget": monthly_budget,
        "required_monthly_savings": required_monthly_savings,
        "remaining_budget": remaining_budget
    }

    # Save the goal data to CSV
    save_goal_to_csv(goal_data)

    return jsonify({
        "goal": goal_name,
        "goal_amount": goal_amount,
        "months": months,
        "monthly_budget": monthly_budget,
        "required_monthly_savings": required_monthly_savings,
        "remaining_budget": remaining_budget,
        "stock_trends": stock_trends  # Include stock trends in the response
    })

@app.route("/get-goals", methods=["GET"])
def get_goals():
    """Fetch all goals from the CSV file."""
    goals = read_goals_from_csv()
    return jsonify(goals)

if __name__ == "__main__":
    app.run(debug=True, port=5001)