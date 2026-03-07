import 'package:flutter/material.dart';
import '../../../shared/models/insurance_model.dart';

class InsuranceDetailPage extends StatelessWidget {
  final InsuranceInfo insurance;

  const InsuranceDetailPage({super.key, required this.insurance});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthYear = "${_getMonth(now.month)} ${now.year}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B3A76)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          insurance.title,
          style: const TextStyle(
            color: Color(0xFF0B3A76),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main premium card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insurance.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(insurance.premium, perYear: true),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  Text(
                    "Annual Premium for $monthYear",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (insurance.subtitle.toLowerCase().contains("takaful") ||
                      insurance.title.toLowerCase().contains("takaful") ||
                      insurance.bullets.any((b) => b.toLowerCase().contains("shariah")))
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B3A76).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 18, color: Color(0xFF0B3A76)),
                          SizedBox(width: 6),
                          Text(
                            "Shariah Compliant",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0B3A76),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Product information card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Product Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem("Coverage Amount", _formatCurrency(insurance.coverage)),
                      _infoItem("Premium Term", insurance.term),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 24),
                  _feeRow("Sales Fee", "0.00%"),
                  _feeRow("Policy Fee", "RM 60/yr"),
                  _feeRow("Management Fee*", "0.30%"),
                  _feeRow("Trustee Fee*", "0.02%"),
                  const SizedBox(height: 8),
                  const Text(
                    "*Subject to 8% SST at fund level.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About this plan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About this Plan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _generateDescription(insurance),
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Supporting documents
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Supporting Documents",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _docTile(context, "Product Disclosure Sheet"),
                  _docTile(context, "Policy Contract"),
                  _docTile(context, "Benefit Illustration"),
                  _docTile(context, "Terms & Conditions"),
                  _docTile(context, "Annual Report"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // CASH IN NOW button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Purchase ${insurance.title}")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B3A76),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "CASH IN NOW",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B3A76))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _feeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _docTile(BuildContext context, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.insert_drive_file,
          color: Color(0xFF0B3A76), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening $title")),
        );
      },
    );
  }

  String _generateDescription(InsuranceInfo insurance) {
    switch (insurance.title) {
      case 'LifeSecure Pro':
        return "LifeSecure Pro is a whole life insurance plan that provides lifetime coverage with cash value accumulation. It offers flexible premium payment options and guarantees financial protection for your loved ones. Suitable for individuals seeking long-term security and savings.";
      case 'MediShield Plus':
        return "MediShield Plus offers comprehensive medical coverage including inpatient and outpatient expenses, with an annual limit up to RM 1,000,000. Enjoy no co-payment and a wide panel of hospitals. Ideal for those wanting peace of mind against rising healthcare costs.";
      case 'RetireEasy Annuity':
        return "RetireEasy Annuity is a retirement plan that guarantees monthly payouts from your chosen retirement age (55 or 60) until age 85. It provides tax relief on contributions and ensures a steady income stream during your golden years.";
      case 'TermGuard':
        return "TermGuard is a pure protection term life insurance plan with affordable premiums. Choose coverage terms of 10, 20, or 30 years, and enjoy the option to convert to a whole life policy later. Perfect for covering temporary financial obligations.";
      case 'InvestLink Elite':
        return "InvestLink Elite is an investment-linked plan that combines life protection with investment opportunities. You can choose from various unit funds and make partial withdrawals when needed. Designed for those who want growth potential with insurance cover.";
      case 'CriticalCare':
        return "CriticalCare provides a lump sum payment upon diagnosis of any of 36 critical illnesses. It helps cover medical expenses and replace lost income during recovery. Coverage continues until age 70, with a survival benefit included.";
      default:
        return "${insurance.title} is a comprehensive insurance plan designed to meet your protection and savings needs. Please refer to the product disclosure sheet for full details.";
    }
  }

  String _formatCurrency(double amount, {bool perYear = false}) {
    if (amount >= 1000000) {
      return 'RM ${(amount / 1000000).toStringAsFixed(1)}M${perYear ? '/yr' : ''}';
    } else if (amount >= 1000) {
      return 'RM ${(amount / 1000).toStringAsFixed(0)}k${perYear ? '/yr' : ''}';
    } else {
      return 'RM ${amount.toStringAsFixed(0)}${perYear ? '/yr' : ''}';
    }
  }

  String _getMonth(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}