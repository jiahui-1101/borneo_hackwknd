// lib/features/spending/pages/retirement_page.dart
import 'package:flutter/material.dart';

class RetirementPage extends StatelessWidget {
  const RetirementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Retirement")),
      body: const Center(
        child: Text("Retirement Page"),
      ),
    );
  }
}