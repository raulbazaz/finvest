import 'package:finvest/components/whitespace.dart';
import 'package:finvest/components/custom_appbar.dart';
import 'package:finvest/components/piechart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String finalcategoryname;
  final String finalexpensename;
  final double finalexpense;
  final double finalmonthly;
  final double finaltotal;

  const HomePage(
      {super.key,
      required this.finalmonthly,
      required this.finaltotal,
      required this.finalcategoryname,
      required this.finalexpense,
      required this.finalexpensename});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> expenseData = {};

  void updateExpenseData(String category, double amount) {
    setState(() {
      expenseData.update(category, (value) => value + amount,
          ifAbsent: () => amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppbar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Piechart(
            expenseData: {
              "Food": 500.0,
              "Transport": 300.0,
              "Shopping": 700.0,
              "Bills": 400.0,
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Whitespace(
              finalcategoryname: widget.finalcategoryname,
              finalexpense: widget.finalexpense,
              finalexpensename: widget.finalexpensename,
              text: 'Recent Expenses',
              monthlybudget: widget.finalmonthly,
              totalexpenses: widget.finaltotal,
            ),
          ),
        ],
      ),
    );
  }
}
