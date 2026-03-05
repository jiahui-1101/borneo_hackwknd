// lib/features/spending/pages/savings_page.dart
import 'package:flutter/material.dart';
import 'package:my_huat/features/homepage/widgets/total_assets.dart';

import 'record_spending_page.dart';
import 'bnpl_calculator_page.dart';
import 'retirement_page.dart';
import 'spending_history_page.dart'; // 🌟 Added import for the history page

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

            const SizedBox(height: 32), // Added spacing

            // 🌟 NEW: Recent Spending Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Spending",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SpendingHistoryPage()),
                    );
                  },
                  child: const Text("See All", style: TextStyle(color: Color(0xFF0D3A6D))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Mock data items to show the layout
            _buildRecentItem("Chicken Rice", "Food", "12.00", Icons.restaurant, Colors.orange.shade100),
            _buildRecentItem("Grab Bus", "Transport", "5.00", Icons.directions_bus, Colors.blue.shade100),
          ],
        ),
      ),
    );
  }

  // 🌟 NEW: Helper widget to build the recent spending cards
  Widget _buildRecentItem(String title, String category, String amount, IconData icon, Color iconBgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: const Color(0xFF0D3A6D), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(category, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text("- RM $amount", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15)),
        ],
      ),
    );
  }

  // Your original Quick Action button builder
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