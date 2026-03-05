// lib/features/spending/pages/savings_page.dart
import 'package:flutter/material.dart';
import 'package:my_huat/features/homepage/widgets/total_assets.dart';

import 'record_spending_page.dart';
import 'bnpl_calculator_page.dart';
import 'retirement_page.dart';

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
            // Header
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

            // Total Assets Card
            const TotalAssetsCard(),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // Horizontal action buttons with colored circles
            Row(
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.receipt_long_rounded,
                  label: "Record Spending",
                  circleColor: Colors.orange.shade100,
                  iconColor: Colors.orange.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecordSpendingPage()),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  icon: Icons.calculate,
                  label: "BNPL Calculator",
                  circleColor: Colors.purple.shade100,
                  iconColor: Colors.purple.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BnplCalculatorPage()),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  icon: Icons.elderly,
                  label: "Retirement Planner",
                  circleColor: Colors.green.shade100,
                  iconColor: Colors.green.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RetirementPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color circleColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255), 
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: circleColor,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0), 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}