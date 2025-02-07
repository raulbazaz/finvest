import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  final String expensename;
  final double expense;
  final String categoryname;
  const Expenses(
      {super.key,
      required this.expensename,
      required this.expense,
      required this.categoryname});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 290,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 10),
        child: Align(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$expensename - $expense',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Category - $categoryname',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
