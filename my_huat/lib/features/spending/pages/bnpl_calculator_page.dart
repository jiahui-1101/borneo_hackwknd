// lib/features/spending/pages/bnpl_calculator_page.dart
import 'package:flutter/material.dart';

class BnplCalculatorPage extends StatelessWidget {
  const BnplCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BNPL Calculator")),
      body: const Center(
        child: Text("BNPL Calculator Page"),
      ),
    );
  }
}