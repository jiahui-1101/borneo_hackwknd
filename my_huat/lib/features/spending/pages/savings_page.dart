// lib/features/spending/pages/savings_page.dart
import 'package:flutter/material.dart';

import 'record_spending_page.dart';
import 'bnpl_calculator_page.dart';
import 'retirement_page.dart';
import '../../../shared/widgets/action_card.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Savings",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              "What do you want to do today?",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),

            ActionCard(
              title: "Record Spending",
              subtitle: "Log today's expenses quickly",
              icon: Icons.receipt_long_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecordSpendingPage()),
                );
              },
            ),
            const SizedBox(height: 14),

            ActionCard(
              title: "BNPL Calculator",
              subtitle: "See monthly debt & repayment",
              icon: Icons.calculate,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BnplCalculatorPage()),
                );
              },
            ),
            const SizedBox(height: 14),

            ActionCard(
              title: "Retirement Planner",
              subtitle: "Plan your future savings",
              icon: Icons.spa,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RetirementPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
