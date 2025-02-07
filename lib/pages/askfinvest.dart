import 'package:flutter/material.dart';

class Askfinvest extends StatefulWidget {
  const Askfinvest({super.key});

  @override
  State<Askfinvest> createState() => _AskfinvestState();
}

class _AskfinvestState extends State<Askfinvest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Text(
        'askfinvest',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
