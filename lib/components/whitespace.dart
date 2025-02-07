import 'package:finvest/components/add_button.dart';
import 'package:finvest/components/expenses.dart';
import 'package:flutter/material.dart';

class Whitespace extends StatefulWidget {
  final String finalexpensename;
  final String finalcategoryname;
  final double finalexpense;
  final String text;
  final double totalexpenses;
  final double monthlybudget;
  const Whitespace(
      {super.key,
      required this.finalcategoryname,
      required this.finalexpense,
      required this.finalexpensename,
      required this.text,
      required this.totalexpenses,
      required this.monthlybudget});

  @override
  State<Whitespace> createState() => _WhitespaceState();
}

class _WhitespaceState extends State<Whitespace> {
  List<Map<String, dynamic>> expenses = [];

  void _addExpenseContainer() {
    setState(() {
      expenses.add({
        'expensename': widget.finalexpensename,
        'categoryname': widget.finalcategoryname,
        'expense': widget.finalexpense,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 496,
      width: 400,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          children: [
            Text(
              widget.text,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Total Expenses: ₹${widget.totalexpenses}',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Monthly Budget: ₹${widget.monthlybudget}',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AddButton(
                    onAddButtonPressed: _addExpenseContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0), // Adds space between items
                      child: Expenses(
                        expense: expense['expense'],
                        expensename: expense['expensename'],
                        categoryname: expense['categoryname'],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
