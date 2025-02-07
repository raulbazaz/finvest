import 'package:finvest/components/linearbar.dart';
import 'package:finvest/components/whitespacewallet.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  final double totalbalance;
  final double totalexpenses;
  const Wallet(
      {super.key, required this.totalbalance, required this.totalexpenses});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text(
              "Wallet",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 170,
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.notifications,
                color: Color(0xFF90EE90),
                size: 30,
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFF90EE90),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Total Balance - ${widget.totalbalance}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Total Expenses - ${widget.totalexpenses}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 30),
            child: BalanceBar(
                totalbalance: widget.totalbalance,
                totalexpenses: widget.totalexpenses),
          ),
          const SizedBox(
            height: 92,
          ),
          Whitespacewallet()
        ],
      ),
    );
  }
}
