import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BalanceBar extends StatelessWidget {
  final double totalexpenses;
  final double totalbalance;
  const BalanceBar(
      {super.key, required this.totalbalance, required this.totalexpenses});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: 350,
      animation: true,
      barRadius: Radius.circular(15),
      lineHeight: 20,
      progressColor: Colors.white,
      backgroundColor: Color(0xFF90EE90),
      percent: (totalexpenses / totalbalance).clamp(0.0, 1.0),
    );
  }
}
