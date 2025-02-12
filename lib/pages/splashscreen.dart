import 'package:finvest/components/next_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Splashscreen extends StatelessWidget {
  void nextbuttonfunction(context) {
    Navigator.pushNamed(context, '/navbar');
  }
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          Center(
            child: Text(
              'Finvest',
              style: TextStyle(color: Color(0XFF90EE90), fontSize: 50),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Elevate your ',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              DefaultTextStyle(
                style: GoogleFonts.averiaSerifLibre(
                    color: Colors.white, fontSize: 20),
                child: AnimatedTextKit(
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    TypewriterAnimatedText('Money!'),
                    TypewriterAnimatedText('Savings!'),
                    TypewriterAnimatedText('Investment!'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Center(child: Image.asset('assets/splashscreen.png')),
          const SizedBox(
            height: 50,
          ),
          Center(
              child: NextButton(
            nextbuttonfunc: (){
              nextbuttonfunction(context);
            },
          ))
        ],
      ),
    );
  }
}
