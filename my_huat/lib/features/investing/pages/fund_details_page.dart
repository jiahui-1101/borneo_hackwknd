import 'package:flutter/material.dart';
import '../../../shared/models/fund_model.dart';
import 'package:my_huat/features/homepage/widgets/cash_in_screen.dart';
import 'package:my_huat/shared/models/fund_type.dart';

class FundDetailPage extends StatelessWidget {
  final FundInfo fund;

  const FundDetailPage({super.key, required this.fund});

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
          fund.title,
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
            // Main performance card
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
                    fund.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${fund.oneYear.toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  Text(
                    "Base Nett Returns for $monthYear",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  if (fund.subtitle.toLowerCase().contains("shariah") ||
                      fund.title.toLowerCase().contains("shariah") ||
                      fund.bullets.any((b) => b.contains("Shariah")))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B3A76).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Color(0xFF0B3A76),
                          ),
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

            // Product information card (fees, min investment)
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
                      _infoItem(
                        "Unit Price",
                        "RM ${fund.unitPrice.toStringAsFixed(4)}",
                      ),
                      _infoItem("Min. Investment", "RM 10.00"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 24),
                  _feeRow("Sales Fee", "0.00%"),
                  _feeRow("Redemption Fee", "0.00%"),
                  _feeRow("Management Fee*", "0.50%"),
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

            // About this fund (description)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About this Fund",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B3A76),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _generateDescription(fund),
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
                  _docTile(context, "Fund Fact Sheet"),
                  _docTile(context, "Fund Fact Sheet (CH)"),
                  _docTile(context, "Product Highlight Sheet"),
                  _docTile(context, "Prospectus"),
                  _docTile(context, "Annual Report"),
                  _docTile(context, "Interim Report"),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CashInScreen(fundType: FundType.investment),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B3A76),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "CASH IN NOW",
                  style: const TextStyle(
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
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B3A76),
          ),
        ),
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
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _docTile(BuildContext context, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(
        Icons.insert_drive_file,
        color: Color(0xFF0B3A76),
        size: 22,
      ),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Opening $title")));
      },
    );
  }

  String _generateDescription(FundInfo fund) {
    switch (fund.title) {
      case 'MHuat Gold':
        return "This fund offers direct exposure to gold prices by tracking a gold benchmark. Gold is a traditional safe‑haven asset that helps hedge against inflation and market turbulence. Suitable for investors seeking portfolio diversification and wealth preservation.";
      case 'MHuat Malaysia Bond':
        return "Invests primarily in Malaysian government and corporate bonds, aiming to generate stable interest income. The fund carries low risk and offers steady returns, making it ideal for conservative investors seeking fixed income.";
      case 'MHuat China Equity Tracker':
        return "Tracks the performance of Chinese equities, including A‑shares and H‑shares, to capture growth opportunities in China's economy. Designed for investors with a long‑term horizon who are comfortable with higher volatility.";
      case 'MHuat Growth':
        return "Allocates a high proportion to global equities (especially US stocks) to pursue long‑term capital appreciation. Suitable for aggressive investors with a higher risk tolerance and long investment horizon.";
      case 'MHuat Global-i':
        return "Focuses on global technology and thematic Shariah‑compliant stocks, allowing participation in innovation‑driven growth. Ideal for those seeking global diversification while adhering to Islamic principles.";
      case 'MHuat Dividend+':
        return "Concentrates on high‑dividend stocks in Malaysia and Asia, aiming to deliver consistent income and capital growth. Best for investors who desire regular cash flow and can accept moderate to high risk.";
      case 'MHuat India Equity':
        return "Provides exposure to the Indian equity market through the Franklin India Fund strategy. India offers strong growth potential but comes with higher volatility, making it suitable for long‑term investors.";
      case 'MHuat Moderate':
        return "Balances equity and fixed income investments to achieve moderate growth with controlled risk. An excellent core holding for investors with a medium risk appetite.";
      case 'MHuat REITs':
        return "Invests in real estate investment trusts (REITs) across the Asia‑Pacific region (ex‑Japan), offering rental income and capital appreciation. Perfect for those wanting property exposure without direct ownership.";
      case 'MHuat US-Tech':
        return "Targets leading US technology companies and emerging innovators, capturing trends like AI and cloud computing. High‑growth potential comes with elevated volatility, suited for aggressive investors.";
      case 'MHuat Japan':
        return "Invests in Japanese equities across consumer, technology, and industrial sectors. Japan's stable economy and improving corporate governance make this fund a good diversifier for developed market exposure.";
      case 'MHuat SGD':
        return "Invests in Singapore dollar‑denominated assets such as bonds and deposits, providing stable returns and a hedge against MYR depreciation. Ideal for conservative investors seeking foreign currency exposure.";
      default:
        return "${fund.title} is a dynamically managed fund that seeks long‑term capital appreciation by identifying market opportunities. Please refer to the prospectus for detailed investment strategy.";
    }
  }

  String _getMonth(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
