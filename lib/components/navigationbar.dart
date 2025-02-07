import 'package:finvest/pages/askfinvest.dart';
import 'package:finvest/pages/home_page.dart';
import 'package:finvest/pages/stocks.dart';
import 'package:finvest/pages/wallet.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AskFinvestChatbot(),
    StockInfoPage(),
    Wallet(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/homebutton.png'),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/assist.png'),
            label: "Ask Finvest",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/statement.png'),
            label: "Stocks",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/wallet.png'),
            label: "Wallet",
          ),
        ],
      ),
    );
  }
}
