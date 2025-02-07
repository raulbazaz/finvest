import 'package:finvest/components/whitespace.dart';
import 'package:finvest/components/custom_appbar.dart';
import 'package:finvest/components/piechart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> expenseData = {};
  double totalExpenses = 0.0;
  double monthlyBudget = 30000.0;

  void fetchSummary() async {
    final url = Uri.parse("http://localhost:5002/summary");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        totalExpenses = data['total_spent'];
        expenseData = Map<String, double>.from(data['expenses_by_category']);
      });
    } else {
      print("Error fetching summary: \${response.body}");
    }
  }

  Future<void> _addExpenseContainer() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Expense"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Expense Name"),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: "Category"),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final url = Uri.parse("http://10.0.2.2:5002/add-expense");
                final response = await http.post(
                  url,
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "name": nameController.text,
                    "category": categoryController.text,
                    "amount": double.tryParse(amountController.text) ?? 0.0,
                  }),
                );
                if (response.statusCode == 201) {
                  fetchSummary();
                }
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppbar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PieChartWidget(expenseData: expenseData,monthlyBudget: monthlyBudget, totalExpenses: totalExpenses,),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Whitespace(
                finalcategoryname: "",
                finalexpense: 0.0,
                finalexpensename: "",
                text: 'Recent Expenses',
                monthlybudget: monthlyBudget,
                totalexpenses: totalExpenses,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: _addExpenseContainer,
              child: Text("Add Expense", style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
