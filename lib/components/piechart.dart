import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> expenseData;
  final double totalExpenses;
  final double monthlyBudget;

  const PieChartWidget({
    super.key,
    required this.expenseData,
    required this.totalExpenses,
    required this.monthlyBudget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _generateSections(),
                centerSpaceRadius: 50,
                sectionsSpace: 5,
              ),
            ),
          ),
          Text(
            'Budget: ₹${monthlyBudget.toStringAsFixed(0)} | Spent: ₹${totalExpenses.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    return expenseData.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
        color: _getColor(entry.key),
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();
  }

  Color _getColor(String key) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];
    return colors[key.hashCode % colors.length];
  }
}
