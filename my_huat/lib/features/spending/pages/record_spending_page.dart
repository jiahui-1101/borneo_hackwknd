// lib/features/spending/pages/record_spending_page.dart
import 'package:flutter/material.dart';

class RecordSpendingPage extends StatelessWidget {
  const RecordSpendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Record Spending")),
      body: const Center(
        child: Text("Record Spending Page"),
      ),
    );
  }
}