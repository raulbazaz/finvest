import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Piechart extends StatelessWidget {
  final Map<String, double> expenseData; // Data from another file

  const Piechart({super.key, required this.expenseData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _generateSections(),
          centerSpaceRadius: 50, // Makes it a ring chart
          sectionsSpace: 5,
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    return expenseData.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
        color: _getRandomColor(entry.key),
        radius: 60,
        titleStyle: TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();
  }

  Color _getRandomColor(String key) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];
    return colors[
        key.hashCode % colors.length]; // Assigns a color based on key hash
  }
}
