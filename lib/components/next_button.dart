import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final void Function() nextbuttonfunc;
  const NextButton({super.key, required this.nextbuttonfunc});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Color(0XFF90EE90)),
      onPressed: () {
        nextbuttonfunc();
      },
      child: Icon(
        Icons.arrow_forward,
        color: Colors.black,
      ),
    );
  }
}
