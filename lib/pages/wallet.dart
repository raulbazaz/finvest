import 'package:finvest/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Wallet extends StatefulWidget {
  const Wallet({super.key});
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<Wallet> {
  final _goalController = TextEditingController();
  final _amountController = TextEditingController();
  final _monthsController = TextEditingController();
  Map<String, dynamic> goalDetails = {};
  Map<String, dynamic> stockTrends = {};
  bool _isLoading = false;
  List<dynamic> savedGoals = []; // To store fetched goals

  @override
  void initState() {
    super.initState();
    _fetchGoals(); // Fetch goals when the page loads
  }

  Future<void> _fetchGoals() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5001/get-goals'));
      if (response.statusCode == 200) {
        setState(() {
          savedGoals = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to fetch goals: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching goals: $e')),
      );
    }
  }

  Future<void> _setGoal() async {
    final amount = double.tryParse(_amountController.text);
    final months = int.tryParse(_monthsController.text);

    if (amount == null || months == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid input. Please enter valid numbers.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/set-goal'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'goal': _goalController.text,
          'amount': amount,
          'months': months,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          goalDetails = {
            'monthly_budget':
                double.parse(responseData['monthly_budget'].toStringAsFixed(2)),
            'required_monthly_savings': double.parse(
                responseData['required_monthly_savings'].toStringAsFixed(2)),
            'remaining_budget': double.parse(
                responseData['remaining_budget'].toStringAsFixed(2)),
          };
          stockTrends = responseData['stock_trends'];
        });
        _fetchGoals(); // Refresh the list of goals
        _clearInputFields(); // Clear input fields
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearInputFields() {
    _goalController.clear();
    _amountController.clear();
    _monthsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8),),
              child: Column(
                children: [
                  TextField(
                    controller: _goalController,
                    decoration: const InputDecoration(hintText: 'Goal', fillColor: Colors.black, filled: true,hintStyle: TextStyle(color: Colors.white)),
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(hintText: 'Amount', fillColor: Colors.black, filled: true,hintStyle: TextStyle(color: Colors.white),),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _monthsController,
                    decoration: const InputDecoration(hintText: 'Months', fillColor: Colors.black, filled: true,hintStyle: TextStyle(color: Colors.white)),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height:20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _setGoal,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Set Goal'),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
            if (goalDetails.isNotEmpty)
              Column(
                children: [
                  ListTile(
                    title: const Text('Monthly Budget',style: TextStyle(color: Colors.white),),
                    subtitle: Text('\$${goalDetails['monthly_budget']}',style: TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    title: const Text('Required Monthly Savings',style: TextStyle(color: Colors.white),),
                    subtitle:
                        Text('\$${goalDetails['required_monthly_savings']}',style: TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    title: const Text('Remaining Budget',style: TextStyle(color: Colors.white),),
                    subtitle: Text('\$${goalDetails['remaining_budget']}',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            if (savedGoals.isNotEmpty)
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.zero, bottomRight: Radius.zero, topLeft: Radius.circular(50), topRight: Radius.circular(50),),),
                    child: ListView.builder(
                      itemCount: savedGoals.length,
                      itemBuilder: (context, index) {
                        final goal = savedGoals[index];
                        return ListTile(
                          title: Text(goal['Goal']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Amount: \$${double.parse(goal['Goal Amount'].toString()).toStringAsFixed(2)},',
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Months: ${goal['Months']}',
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Required Savings: \$${double.parse(goal['Required Monthly Savings'].toString()).toStringAsFixed(2)}',
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Remaining Budget: \$${double.parse(goal['Remaining Budget'].toString()).toStringAsFixed(2)}'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
