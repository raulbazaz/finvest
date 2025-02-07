import 'package:finvest/components/add_button.dart';
import 'package:finvest/components/expenses.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  void _addExpenseContainer() async {
    final url = Uri.parse("http://10.0.2.2:5002/add-expense");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": widget.finalexpensename,
        "category": widget.finalcategoryname,
        "amount": widget.finalexpense,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        expenses.add({
          'expensename': widget.finalexpensename,
          'categoryname': widget.finalcategoryname,
          'expense': widget.finalexpense,
        });
      });
    } else {
      print("Error adding expense: \${response.body}");
    }
  }

  void fetchExpenses() async {
    final url = Uri.parse("http://10.0.2.2:5002/expenses");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> expenseList = jsonDecode(response.body);
      setState(() {
        expenses = expenseList.map((e) => {
          'expensename': e['name'],
          'categoryname': e['category'],
          'expense': e['amount'],
        }).toList();
      });
    } else {
      print("Error fetching expenses: \${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExpenses();
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
            const SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses: ₹${widget.totalexpenses}',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Monthly Budget: ₹ ${widget.monthlybudget}',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
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
