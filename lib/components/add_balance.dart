import 'package:flutter/material.dart';

class AddBalance extends StatelessWidget {
  final VoidCallback onAddBalancePressed;

  const AddBalance({Key? key, required this.onAddBalancePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Color(0xFF90EE90)),
      onPressed: onAddBalancePressed,
      child: Text(
        'Add Balance',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
