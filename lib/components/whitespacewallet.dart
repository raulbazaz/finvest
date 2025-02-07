import 'package:finvest/components/add_button.dart';
import 'package:flutter/material.dart';

class Whitespacewallet extends StatelessWidget {
  void onAddButtonPressed() {}
  const Whitespacewallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Container(
        height: 496,
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50)),
            color: Colors.white),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Goals',
              style: TextStyle(fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [AddButton(onAddButtonPressed: onAddButtonPressed)],
              ),
            )
          ],
        ),
      ),
    );
  }
}
