import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Whitespacewallet extends StatefulWidget {
  final Function onGoalAdded; // Callback to refresh goals

  const Whitespacewallet({super.key, required this.onGoalAdded});

  @override
  _WhitespacewalletState createState() => _WhitespacewalletState();
}

class _WhitespacewalletState extends State<Whitespacewallet> {
  List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5001/get-goals'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          goals = data.map((goal) {
            return {
              "goal": goal["goal"] ?? "Unknown Goal",
              "goal_amount": goal["goal_amount"] ?? 0.0,
              "months": goal["months"] ?? 1,
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching goals: $e");
    }
  }

  void _showAddGoalDialog() {
    TextEditingController goalController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController monthsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set a Goal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: goalController, decoration: InputDecoration(labelText: "Goal Name")),
              TextField(controller: amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
              TextField(controller: monthsController, decoration: InputDecoration(labelText: "Months"), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String goal = goalController.text;
                double amount = double.tryParse(amountController.text) ?? 0;
                int months = int.tryParse(monthsController.text) ?? 1;

                if (goal.isNotEmpty && amount > 0 && months > 0) {
                  await setGoal(goal, amount, months);
                  widget.onGoalAdded(); // Refresh goals in wallet.dart
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> setGoal(String goal, double amount, int months) async {
    await http.post(
      Uri.parse('http://10.0.2.2:5001/set-goal'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"goal": goal, "goal_amount": amount, "months": months}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _showAddGoalDialog,
          child: Text("Add Goal"),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return ListTile(
              title: Text(goal["goal"], style: TextStyle(color: Colors.white)),
              subtitle: Text(
                "₹${goal["goal_amount"]} in ${goal["months"]} months",
                style: TextStyle(color: Colors.white70),
              ),
            );
          },
        ),
      ],
    );
  }
}
