// lib/features/spending/pages/savings_page.dart
import 'package:flutter/material.dart';
import 'package:my_huat/features/homepage/widgets/total_assets.dart';
import 'package:my_huat/shared/data_service.dart';
import 'record_spending_page.dart';
import 'bnpl_calculator_page.dart';
import 'retirement_page.dart';
import 'spending_history_page.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  IconData _getCatIcon(String? cat) => cat == 'Food'
      ? Icons.restaurant
      : (cat == 'Transport' ? Icons.directions_bus : Icons.receipt);
  Color _getCatColor(String? cat) => cat == 'Food'
      ? Colors.orange.shade100
      : (cat == 'Transport' ? Colors.blue.shade100 : Colors.purple.shade100);

  @override
  Widget build(BuildContext context) {
    // 🌟 SMART FALLBACK: Use real data if available, otherwise show mock data for the demo
    final List<Map<String, dynamic>> displayRecords =
        DataService.allRecords.isNotEmpty
        ? DataService.allRecords.take(3).toList()
        : [
            {'title': 'Hackathon RedBull', 'category': 'Food', 'amount': 6.50},
            {'title': 'Grab to UTM', 'category': 'Transport', 'amount': 15.00},
            {
              'title': 'Figma Subscription',
              'category': 'Shopping',
              'amount': 55.00,
            },
          ];

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

            const TotalAssetsCard(),
            const SizedBox(height: 24),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.receipt_long_rounded,
                  label: "Record Spending",
                  circleColor: Colors.orange.shade100,
                  iconColor: Colors.orange.shade800,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecordSpendingPage(),
                      ),
                    );
                    setState(() {});
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  icon: Icons.calculate,
                  label: "BNPL Calculator",
                  circleColor: Colors.purple.shade100,
                  iconColor: Colors.purple.shade800,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BnplCalculatorPage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  icon: Icons.elderly,
                  label: "Retirement Planner",
                  circleColor: Colors.green.shade100,
                  iconColor: Colors.green.shade800,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RetirementPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Spending",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SpendingHistoryPage(),
                      ),
                    );
                    setState(() {});
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(color: Color(0xFF0D3A6D)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🌟 Use the dynamic displayRecords list here
            Column(
              children: displayRecords.map((item) {
                return _buildRecentItem(
                  item['title'] ?? 'New Record',
                  item['category'] ?? 'Others',
                  (item['amount'] as double).toStringAsFixed(2),
                  _getCatIcon(item['category']),
                  _getCatColor(item['category']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItem(
    String title,
    String category,
    String amount,
    IconData icon,
    Color iconBgColor,
  ) {
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
          ),
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
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "- RM $amount",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 15,
            ),
          ),
        ],
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
            height: 120, // fixed height for all buttons
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: circleColor,
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
