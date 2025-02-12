import 'package:finvest/components/navigationbar.dart';
import 'package:finvest/pages/home_page.dart';
import 'package:finvest/pages/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.averiaSerifLibreTextTheme()),
      home: Splashscreen(),
      routes: {
        '/navbar': (context) => CustomNavBar(),
      },
    );
  }
}
