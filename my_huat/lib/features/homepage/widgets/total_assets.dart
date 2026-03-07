import 'package:flutter/material.dart';
import 'package:my_huat/shared/models/fund_type.dart'; // adjust path if needed
import 'package:my_huat/features/homepage/widgets/cash_in_screen.dart'; // for navigation

class TotalAssetsCard extends StatelessWidget {
  const TotalAssetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final total =
        FundType.insurance.currentBalance +
        FundType.saving.currentBalance +
        FundType.investment.currentBalance;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0EDFE),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7EBEFB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: const Color(0xFF0D3A6D),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "TOTAL ASSETS",
                style: TextStyle(
                  color: Color(0xFF084584),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total amount
          Text(
            "RM ${total.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D3A6D),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Breakdown row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFundTile(
                icon: Icons.health_and_safety,
                label: 'Insurance',
                amount: FundType.insurance.currentBalance,
              ),
              _buildFundTile(
                icon: Icons.savings,
                label: 'Saving',
                amount: FundType.saving.currentBalance,
              ),
              _buildFundTile(
                icon: Icons.trending_up,
                label: 'Investment',
                amount: FundType.investment.currentBalance,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // CASH IN button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1080E7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              onPressed: () => _showFundSelection(context),
              child: const Text(
                "CASH IN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundTile({
    required IconData icon,
    required String label,
    required double amount,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0462C2), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF05509F),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "RM ${amount.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Color(0xFF0D3A6D),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showFundSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Fund',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D3A6D),
              ),
            ),
            const SizedBox(height: 16),
            ...FundType.values.map((fund) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0EDFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      fund == FundType.insurance
                          ? Icons.health_and_safety
                          : fund == FundType.saving
                          ? Icons.savings
                          : Icons.trending_up,
                      color: const Color(0xFF0462C2),
                    ),
                  ),
                  title: Text(
                    fund.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D3A6D),
                    ),
                  ),
                  subtitle: Text(
                    'Current Balance: RM ${fund.currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF05509F),
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF0462C2),
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CashInScreen(fundType: fund),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
