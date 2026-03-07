import 'package:flutter/material.dart';
import 'package:my_huat/shared/models/fund_type.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

class CashInScreen extends StatefulWidget {
  final FundType fundType;
  const CashInScreen({super.key, required this.fundType});

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  final TextEditingController _referralController = TextEditingController();
  String? _selectedAmount;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'CIMB Clicks', 'icon': Icons.account_balance},
    {'name': 'FPX Online Banking', 'icon': Icons.payment},
    {'name': 'More options', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ArcHeader at the very top
          const ArcHeader(title: "MHuat"),

          // Back button + screen title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Text(
                  "Purchase Fund",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D3A6D),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fund name and current balance (card style)
                  Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fundType.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D3A6D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Current Balance RM ${widget.fundType.currentBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF05509F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Select Amount (same as before)
                  const Text(
                    'Select Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D3A6D),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildAmountChip('RM10'),
                      const SizedBox(width: 8),
                      _buildAmountChip('RM100'),
                      const SizedBox(width: 8),
                      _buildAmountChip('RM300'),
                      const SizedBox(width: 8),
                      _buildAmountChip('RM500'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Referral code field (using BNPL style)
                  const Text(
                    'Referral Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D3A6D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStyledTextField(
                    controller: _referralController,
                    label: 'Enter Referral Code',
                    icon: Icons.card_giftcard,
                  ),
                  const SizedBox(height: 24),

                  // Payment method selection (custom card list)
                  const Text(
                    'Select Your Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D3A6D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._paymentMethods.map((method) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          method['icon'],
                          color: const Color(0xFF0462C2),
                        ),
                        title: Text(
                          method['name'],
                          style: const TextStyle(color: Color(0xFF0D3A6D)),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF0462C2),
                        ),
                        onTap: () {
                          // handle selection
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 32),

                  // Next button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1080E7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 16,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        // Process cash‑in
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0D3A6D)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D3A6D), width: 2),
        ),
      ),
    );
  }

  Widget _buildAmountChip(String label) {
    final isSelected = _selectedAmount == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedAmount = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1080E7)
                : const Color(0xFFE0EDFE),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1080E7)
                  : const Color(0xFF7EBEFB),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF0D3A6D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
