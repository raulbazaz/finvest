import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onAddButtonPressed;

  const AddButton({Key? key, required this.onAddButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Color(0xFF90EE90)),
      onPressed: onAddButtonPressed,
      child: Text(
        'Add +',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
