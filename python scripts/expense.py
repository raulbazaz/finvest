from datetime import datetime

class Expense:
    def __init__(self, name, category, amount, date=None) -> None:
        self.date = date if date else datetime.today().strftime("%Y-%m-%d")  # Auto-set date if not provided
        self.name = name
        self.category = category
        self.amount = amount

    def __repr__(self):
        return f"<Expense: {self.date}, {self.name}, {self.category}, {self.amount}>"
