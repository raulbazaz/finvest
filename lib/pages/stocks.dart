import 'package:finvest/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockInfoPage extends StatefulWidget {
  const StockInfoPage({super.key});
  @override
  _StockInfoPageState createState() => _StockInfoPageState();
}

class _StockInfoPageState extends State<StockInfoPage> {
  Map<String, dynamic> stockInfo = {};
  Map<String, dynamic> investmentSuggestions = {};

  Future<void> _fetchStockInfo() async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5002/stock-info'), // Change 127.0.0.1 to 10.0.2.2
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'tickers': ['AAPL', 'GOOGL', 'MSFT','RBLX','PINS','FTNT','ELF','NET','TTWO','EXPE','NKLA','NKE','GPRO']}),
  );

  if (response.statusCode == 200) {
    setState(() {
      stockInfo = json.decode(response.body);
    });
  } else {
    print('Failed to fetch stock info: ${response.statusCode}');
  }
}

Future<void> _fetchInvestmentSuggestions() async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5002/investment-suggestions'), // Change 127.0.0.1 to 10.0.2.2 to actually connect to local host and not emulator local host
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'tickers': ['AAPL', 'GOOGL', 'MSFT','RBLX','PINS','FTNT','ELF','NET','TTWO','EXPE','NKLA','NKE','GPRO']}),
  );

  if (response.statusCode == 200) {
    setState(() {
      investmentSuggestions = json.decode(response.body);
    });
  } else {
    print('Failed to fetch investment suggestions: ${response.statusCode}');
  }
}

  @override
  void initState() {
    super.initState();
    _fetchStockInfo();
    _fetchInvestmentSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (stockInfo.isNotEmpty)
                ...stockInfo.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value['name']),
                    subtitle: Text('Price: \$${entry.value['current_price']}'),
                  );
                }).toList(),
              SizedBox(height: 20),
              if (investmentSuggestions.isNotEmpty)
                ...investmentSuggestions.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value['suggestion']),
                    subtitle: Text('${entry.key}: ${entry.value['percentage_change'].toStringAsFixed(2)}%'),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}