// lib/features/spending/pages/savings_page.dart
import 'package:flutter/material.dart';
import 'package:my_huat/features/homepage/widgets/total_assets.dart';
import 'package:my_huat/shared/data_service.dart';
import 'record_spending_page.dart';
import 'bnpl_calculator_page.dart';
import 'retirement_page.dart';
import 'spending_history_page.dart';

// 🌟 1. 改为 StatefulWidget 确保页面可以被刷新
class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  // 🌟 2. 帮助函数：根据分类返回你原本用的图标和颜色
  IconData _getCatIcon(String? cat) => cat == 'Food' ? Icons.restaurant : (cat == 'Transport' ? Icons.directions_bus : Icons.receipt);
  Color _getCatColor(String? cat) => cat == 'Food' ? Colors.orange.shade100 : (cat == 'Transport' ? Colors.blue.shade100 : Colors.purple.shade100);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Savings", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text("What do you want to do today?", style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),

            const TotalAssetsCard(),
            const SizedBox(height: 24),

            const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                    // 🌟 3. 加了 await，回来时会自动刷新
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordSpendingPage()));
                    setState(() {}); 
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(context, icon: Icons.calculate, label: "BNPL Calculator", circleColor: Colors.purple.shade100, iconColor: Colors.purple.shade800, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BnplCalculatorPage()))),
                const SizedBox(width: 12),
                _buildActionButton(context, icon: Icons.elderly, label: "Retirement Planner", circleColor: Colors.green.shade100, iconColor: Colors.green.shade800, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RetirementPage()))),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Spending", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const SpendingHistoryPage()));
                    setState(() {});
                  },
                  child: const Text("See All", style: TextStyle(color: Color(0xFF0D3A6D))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🌟 4. 核心：这里删掉了写死的数据，改用 map 动态生成
            Column(
              children: DataService.allRecords.take(3).map((item) {
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

  // --- 下面 100% 维持你原本的 Widget 样式，一个参数都没改 ---

  Widget _buildRecentItem(String title, String category, String amount, IconData icon, Color iconBgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: iconBgColor, child: Icon(icon, color: const Color(0xFF0D3A6D), size: 20)),
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

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required Color circleColor, required Color iconColor, required VoidCallback onTap}) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 24, backgroundColor: circleColor, child: Icon(icon, color: iconColor, size: 28)),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}