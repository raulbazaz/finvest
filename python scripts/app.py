from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
from expense import Expense
import expense_tracker  # Import functions from expense_tracker.py
import yfinance as yf
from sklearn.linear_model import LinearRegression
import numpy as np
import pandas as pd
from sklearn.metrics import r2_score

app = Flask(__name__)
CORS(app)

# Expense file for storing data
EXPENSE_FILE_PATH = "expenses.csv"
BUDGET = 30000

@app.route("/")
def home():
    return jsonify({"message": "Expense Tracker API is running!"})

# Add an expense (calls save_expense_to_file)
@app.route("/add-expense", methods=["POST"])
def add_expense():
    data = request.json
    if not data or "name" not in data or "category" not in data or "amount" not in data:
        return jsonify({"error": "Missing required fields"}), 400

    expense = Expense(
        date=datetime.today().strftime("%Y-%m-%d"),
        name=data["name"],
        category=data["category"],
        amount=float(data["amount"])
    )

    # Save expense to file
    expense_tracker.save_expense_to_file(expense, EXPENSE_FILE_PATH)

    return jsonify({
        "message": "Expense added successfully!",
        "expense": {"date": expense.date, "name": expense.name, "category": expense.category, "amount": expense.amount}
    }), 201

# Get all expenses (calls summarize_expenses)
@app.route("/expenses", methods=["GET"])
def get_expenses():
    expenses = expense_tracker.read_expenses_from_file(EXPENSE_FILE_PATH)
    if not expenses:
        return jsonify({"message": "No expenses found."}), 404

    return jsonify([
        {"date": exp.date, "name": exp.name, "category": exp.category, "amount": exp.amount}
        for exp in expenses
    ]), 200

# Get expenses by category
@app.route("/expenses/<category>", methods=["GET"])
def get_expenses_by_category(category):
    all_expenses = expense_tracker.read_expenses_from_file(EXPENSE_FILE_PATH)
    
    # Filter expenses based on category
    category_expenses = [
        {"date": exp.date, "name": exp.name, "category": exp.category, "amount": exp.amount}
        for exp in all_expenses if exp.category.lower() == category.lower()
    ]
    
    if not category_expenses:
        return jsonify({"message": "No expenses found in this category"}), 404

    return jsonify(category_expenses), 200

@app.route("/summary", methods=["GET"])
def summary():
    # Read the expenses from the file
    expenses = expense_tracker.read_expenses_from_file(EXPENSE_FILE_PATH)

    if not expenses:
        return jsonify({"message": "No expenses found."}), 404

    # Calculate expenses by category
    amount_by_category = {}
    total_spent = 0
    for expense in expenses:
        total_spent += expense.amount
        if expense.category in amount_by_category:
            amount_by_category[expense.category] += expense.amount
        else:
            amount_by_category[expense.category] = expense.amount

    # Calculate remaining budget
    remaining_budget = BUDGET - total_spent

    # Prepare the summary response
    summary_response = {
        "expenses_by_category": amount_by_category,
        "total_spent": total_spent,
        "remaining_budget": remaining_budget
    }

    return jsonify(summary_response), 200

# Stock-related endpoints
@app.route("/stock-info", methods=["POST"])
def stock_info():
    data = request.json
    tickers = data['tickers']  # List of stock tickers (e.g., ['AAPL', 'GOOGL', 'MSFT'])

    stock_data = {}
    for ticker in tickers:
        stock = yf.Ticker(ticker)
        info = stock.info
        stock_data[ticker] = {
            'name': info.get('longName'),
            'current_price': info.get('currentPrice'),
            'market_cap': info.get('marketCap'),
            'pe_ratio': info.get('trailingPE'),
            'dividend_yield': info.get('dividendYield')
        }

    return jsonify(stock_data)

def predict_stock_price(ticker, days):
    # Fetch historical data
    stock = yf.Ticker(ticker)
    hist = stock.history(period='3y')  # historical data
    hist = hist[['Close']].reset_index()

    # Prepare data for training
    hist['Days'] = (hist['Date'] - hist['Date'].min()).dt.days
    X = hist[['Days']]
    y = hist['Close']

    # Train Linear Regression model
    model = LinearRegression()
    model.fit(X, y)

    # Predict on training data to check accuracy
    y_pred = model.predict(X)
    r2 = r2_score(y, y_pred)  # Compute R² score

    print(f"Model Accuracy (R² Score) for {ticker}: {r2:.4f}")  # Print accuracy

    # Predict future prices
    future_days = np.array(range(hist['Days'].max() + 1, hist['Days'].max() + 1 + days)).reshape(-1, 1)
    predicted_prices = model.predict(pd.DataFrame(future_days, columns=['Days']))

    return jsonify({
        'ticker': ticker,
        'predicted_prices': predicted_prices.tolist()
    })

@app.route("/investment-suggestions", methods=["POST"])
def investment_suggestions():
    data = request.json
    tickers = data['tickers']  # List of stock tickers

    suggestions = {}
    for ticker in tickers:
        # Fetch current price
        stock = yf.Ticker(ticker)
        current_price = stock.info.get('currentPrice')

        # Fetch predicted prices
        response = predict_stock_price(ticker, 30)  # Predict for 30 days
        predicted_prices = response.get_json()['predicted_prices']

        if not predicted_prices:
            continue

        # Calculate percentage change
        predicted_price = predicted_prices[-1]  # Last predicted price
        percentage_change = ((predicted_price - current_price) / current_price) * 100

        # Generate suggestion
        if percentage_change > 5:
            suggestion = "Buying this stock could be profitable"
        elif percentage_change < -5:
            suggestion = "Selling this stock seems like a viable choice"
        else:
            suggestion = "Holding onto this stock seems like a viable choice"

        suggestions[ticker] = {
            'current_price': current_price,
            'predicted_price': predicted_price,
            'percentage_change': percentage_change,
            'suggestion': suggestion
        }

    return jsonify(suggestions)

if __name__ == "__main__":
    app.run(debug=True, port=5002)