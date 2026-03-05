import 'package:flutter/material.dart';

class PortfolioSetupPage extends StatelessWidget {
  const PortfolioSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Set Up Portfolio',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.account_balance_wallet,
              color: Colors.purple,
              size: 28,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Set Up Portfolio Content',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}