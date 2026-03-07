import 'package:flutter/material.dart' hide Badge; // Hide Flutter's Badge to avoid conflict
import 'package:my_huat/shared/models/fund_model.dart';
import 'package:my_huat/shared/models/insurance_model.dart';
import 'package:my_huat/features/investing/pages/fund_details_page.dart';
import 'package:my_huat/features/insurance/pages/insurance_detail_page.dart';

class PortfolioResultsPage extends StatefulWidget {
  final String selectedType; // 'invest' or 'insurance'
  final String recommendedProfile; // e.g., 'Aggressive'

  const PortfolioResultsPage({
    super.key,
    required this.selectedType,
    required this.recommendedProfile,
  });

  @override
  State<PortfolioResultsPage> createState() => _PortfolioResultsPageState();
}

class _PortfolioResultsPageState extends State<PortfolioResultsPage> {
  final Color navyBlue = const Color(0xFF0B3A76);

  // Helper to get icon and color based on profile name
  IconData _getIconForProfile(String name) {
    if (name.contains('Conservative')) return Icons.security;
    if (name.contains('Moderate')) return Icons.balance;
    return Icons.trending_up;
  }

  Color _getColorForProfile(String name) {
    if (name.contains('Very Conservative')) return Colors.blue;
    if (name.contains('Moderately Conservative')) return Colors.lightBlue;
    if (name.contains('Moderate')) return Colors.green;
    if (name.contains('Moderately Aggressive')) return Colors.orange;
    if (name.contains('Aggressive')) return Colors.deepOrange;
    return Colors.red;
  }

  Risk _getRiskForProfile(String name) {
    if (name.contains('Very Conservative') || name.contains('Moderately Conservative')) return Risk.low;
    if (name.contains('Moderate')) return Risk.moderate;
    return Risk.high;
  }

  // Create badge for fund (using Badge from fund_model.dart)
  Badge _createFundBadge(String text, IconData icon, Color color) {
    return Badge(text: text, icon: icon, color: color);
  }

  // Create badge for insurance (using InsuranceBadge from insurance_model.dart)
  InsuranceBadge _createInsuranceBadge(String text, IconData icon, Color color) {
    return InsuranceBadge(text: text, icon: icon, color: color);
  }

  // Risk profiles data using the real imported model classes
  late final List<RiskProfile> _profiles = [
    RiskProfile(
      name: 'Very Conservative',
      description: 'Focus on capital preservation, low risk, mainly money market and short-term bonds.',
      oneMonthReturn: 0.1,
      investProduct: FundInfo(
        title: 'MHuat Money Market',
        subtitle: 'Very Conservative Fund',
        bullets: const ['Low volatility', 'High liquidity'],
        ytd: 2.5,
        oneYear: 2.5,
        risk: _getRiskForProfile('Very Conservative'),
        badges: [
          _createFundBadge('Low Risk', Icons.eco, Colors.green),
          _createFundBadge('Liquid', Icons.water_drop, Colors.blue),
        ],
        iconBg: _getColorForProfile('Very Conservative'),
        icon: _getIconForProfile('Very Conservative'),
      ),
      insuranceProduct: InsuranceInfo(
        title: 'SecureSave',
        subtitle: 'Very Conservative Plan',
        bullets: const ['Guaranteed returns', 'Capital guaranteed'],
        premium: 1200,
        coverage: 100000,
        term: 'Whole Life',
        badges: [
          _createInsuranceBadge('Guaranteed', Icons.verified, Colors.green),
          _createInsuranceBadge('Low Risk', Icons.shield, Colors.blue),
        ],
        iconBg: _getColorForProfile('Very Conservative'),
        icon: _getIconForProfile('Very Conservative'),
      ),
    ),
    RiskProfile(
      name: 'Moderately Conservative',
      description: 'Mix of bonds and some equities for modest growth with lower risk.',
      oneMonthReturn: -0.1,
      investProduct: FundInfo(
        title: 'MHuat Malaysia Bond',
        subtitle: 'Moderately Conservative Fund',
        bullets: const ['Government & corporate bonds', 'Stable income'],
        ytd: 3.8,
        oneYear: 3.8,
        risk: _getRiskForProfile('Moderately Conservative'),
        badges: [
          _createFundBadge('Bond', Icons.account_balance, Colors.blue),
          _createFundBadge('Income', Icons.trending_down, Colors.green),
        ],
        iconBg: _getColorForProfile('Moderately Conservative'),
        icon: _getIconForProfile('Moderately Conservative'),
      ),
      insuranceProduct: InsuranceInfo(
        title: 'BondGuard',
        subtitle: 'Moderately Conservative Plan',
        bullets: const ['Participating plan', 'Annual dividends'],
        premium: 1500,
        coverage: 150000,
        term: '20 years',
        badges: [
          _createInsuranceBadge('Dividend', Icons.money, Colors.green),
          _createInsuranceBadge('Stable', Icons.hourglass_empty, Colors.blue),
        ],
        iconBg: _getColorForProfile('Moderately Conservative'),
        icon: _getIconForProfile('Moderately Conservative'),
      ),
    ),
    RiskProfile(
      name: 'Moderate',
      description: 'Balanced mix of equities and fixed income for steady growth.',
      oneMonthReturn: 0.3,
      investProduct: FundInfo(
        title: 'MHuat Moderate',
        subtitle: 'Balanced Fund',
        bullets: const ['60% equities / 40% bonds', 'Diversified'],
        ytd: 6.2,
        oneYear: 6.2,
        risk: _getRiskForProfile('Moderate'),
        badges: [
          _createFundBadge('Balanced', Icons.balance, Colors.orange),
          _createFundBadge('Diversified', Icons.pie_chart, Colors.green),
        ],
        iconBg: _getColorForProfile('Moderate'),
        icon: _getIconForProfile('Moderate'),
      ),
      insuranceProduct: InsuranceInfo(
        title: 'BalancedLife',
        subtitle: 'Moderate Plan',
        bullets: const ['Investment-linked', 'Flexible premiums'],
        premium: 2000,
        coverage: 200000,
        term: 'To age 65',
        badges: [
          _createInsuranceBadge('Flexible', Icons.tune, Colors.orange),
          _createInsuranceBadge('Growth', Icons.trending_up, Colors.green),
        ],
        iconBg: _getColorForProfile('Moderate'),
        icon: _getIconForProfile('Moderate'),
      ),
    ),
    RiskProfile(
      name: 'Moderately Aggressive',
      description: 'Higher equity exposure for capital appreciation, some volatility.',
      oneMonthReturn: -0.5,
      investProduct: FundInfo(
        title: 'MHuat Growth',
        subtitle: 'Moderately Aggressive Fund',
        bullets: const ['80% equities', 'Global diversification'],
        ytd: 9.5,
        oneYear: 9.5,
        risk: _getRiskForProfile('Moderately Aggressive'),
        badges: [
          _createFundBadge('Growth', Icons.trending_up, Colors.deepOrange),
          _createFundBadge('Global', Icons.public, Colors.blue),
        ],
        iconBg: _getColorForProfile('Moderately Aggressive'),
        icon: _getIconForProfile('Moderately Aggressive'),
      ),
      insuranceProduct: InsuranceInfo(
        title: 'GrowthPlus',
        subtitle: 'Moderately Aggressive Plan',
        bullets: const ['Higher potential returns', 'Unit-linked'],
        premium: 2500,
        coverage: 250000,
        term: '30 years',
        badges: [
          _createInsuranceBadge('High Growth', Icons.rocket, Colors.deepOrange),
          _createInsuranceBadge('Linked', Icons.link, Colors.blue),
        ],
        iconBg: _getColorForProfile('Moderately Aggressive'),
        icon: _getIconForProfile('Moderately Aggressive'),
      ),
    ),
    RiskProfile(
      name: 'Aggressive',
      description: 'High equity allocation, targets maximum long-term growth, accepts high volatility.',
      oneMonthReturn: -0.8,
      investProduct: FundInfo(
        title: 'MHuat US-Tech',
        subtitle: 'Aggressive Fund',
        bullets: const ['US technology stocks', 'High growth potential'],
        ytd: 15.2,
        oneYear: 15.2,
        risk: _getRiskForProfile('Aggressive'),
        badges: [
          _createFundBadge('Tech', Icons.computer, Colors.indigo),
          _createFundBadge('High Risk', Icons.warning, Colors.red),
        ],
        iconBg: _getColorForProfile('Aggressive'),
        icon: _getIconForProfile('Aggressive'),
      ),
      insuranceProduct: InsuranceInfo(
        title: 'Ventura',
        subtitle: 'Aggressive Plan',
        bullets: const ['Aggressive investment strategy', 'Market-linked'],
        premium: 3000,
        coverage: 300000,
        term: 'To age 70',
        badges: [
          _createInsuranceBadge('Aggressive', Icons.flash_on, Colors.red),
          _createInsuranceBadge('Market-linked', Icons.trending_up, Colors.orange),
        ],
        iconBg: _getColorForProfile('Aggressive'),
        icon: _getIconForProfile('Aggressive'),
      ),
    ),
    RiskProfile(
      name: 'Very Aggressive',
      description: 'Maximum equity exposure, may include emerging markets or sector funds, highest risk/return.',
      oneMonthReturn: -1.2,
      investProduct: FundInfo(
        title: 'MHuat China Equity Tracker',
        subtitle: 'Very Aggressive Fund',
        bullets: const ['China A-shares', 'High volatility'],
        ytd: 18.7,
        oneYear: 18.7,
        risk: _getRiskForProfile('Very Aggressive'),
        badges: [
          _createFundBadge('Emerging', Icons.terrain, Colors.purple),
          _createFundBadge('Volatile', Icons.waves, Colors.red),
        ],
        iconBg: _getColorForProfile('Very Aggressive'),
        icon: _getIconForProfile('Very Aggressive'),
      ),
      insuranceProduct: InsuranceInfo(
        title: 'Dynamo',
        subtitle: 'Very Aggressive Plan',
        bullets: const ['100% equities', 'Aggressive growth'],
        premium: 3500,
        coverage: 350000,
        term: 'To age 75',
        badges: [
          _createInsuranceBadge('Max Growth', Icons.star, Colors.red),
          _createInsuranceBadge('High Risk', Icons.warning, Colors.orange),
        ],
        iconBg: _getColorForProfile('Very Aggressive'),
        icon: _getIconForProfile('Very Aggressive'),
      ),
    ),
  ];

  RiskProfile get _recommendedProfile =>
      _profiles.firstWhere((p) => p.name == widget.recommendedProfile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Portfolio',
          style: TextStyle(
            color: navyBlue,
            fontSize: 20,
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
            Text(
              'For You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navyBlue,
              ),
            ),
            const SizedBox(height: 8),
            _buildProfileCard(_recommendedProfile, isRecommended: true),
            const SizedBox(height: 24),
            Text(
              'Other Profiles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            ..._profiles
                .where((p) => p.name != widget.recommendedProfile)
                .map((profile) => _buildProfileCard(profile))
                .toList(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Returns* 1 Month',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '-0.2%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '*Sample returns for illustration only.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(RiskProfile profile, {bool isRecommended = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isRecommended
            ? Border.all(color: navyBlue, width: 2)
            : Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          if (widget.selectedType == 'invest') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FundDetailPage(fund: profile.investProduct),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    InsuranceDetailPage(insurance: profile.insuranceProduct),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: isRecommended ? 18 : 16,
                      fontWeight:
                          isRecommended ? FontWeight.bold : FontWeight.w600,
                      color: navyBlue,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: profile.oneMonthReturn >= 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${profile.oneMonthReturn >= 0 ? '+' : ''}${profile.oneMonthReturn.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: profile.oneMonthReturn >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              if (isRecommended) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: navyBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Recommended for you',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0B3A76),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                profile.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to view recommended ${widget.selectedType == 'invest' ? 'fund' : 'plan'}',
                style: TextStyle(fontSize: 12, color: navyBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Local wrapper class
class RiskProfile {
  final String name;
  final String description;
  final double oneMonthReturn;
  final FundInfo investProduct;
  final InsuranceInfo insuranceProduct;

  RiskProfile({
    required this.name,
    required this.description,
    required this.oneMonthReturn,
    required this.investProduct,
    required this.insuranceProduct,
  });
}