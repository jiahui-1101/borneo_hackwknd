import 'package:flutter/material.dart';
import '../../../shared/widgets/arc_header.dart';
import '../../../shared/models/fund_model.dart' as models;  // 使用别名避免与 Material Badge 冲突
import 'fund_details_page.dart';

class InvestNowPage extends StatefulWidget {
  const InvestNowPage({super.key});

  @override
  State<InvestNowPage> createState() => _InvestNowPageState();
}

class _InvestNowPageState extends State<InvestNowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ArcHeader(title: 'MHuat'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Invest Now',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _InvestPortfolioView()),
        ],
      ),
    );
  }
}

class _InvestPortfolioView extends StatefulWidget {
  const _InvestPortfolioView();

  @override
  State<_InvestPortfolioView> createState() => _InvestPortfolioViewState();
}

class _InvestPortfolioViewState extends State<_InvestPortfolioView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Column(children: [Expanded(child: _InvestList())]),
    );
  }
}

class _InvestList extends StatelessWidget {
  const _InvestList();

  @override
  Widget build(BuildContext context) {
    final funds = <models.FundInfo>[
      models.FundInfo(
        title: 'MHuat Gold',
        subtitle: '(AHAM Shariah Gold Tracker Fund)',
        bullets: const [
          'Direct exposure to Gold',
          'Shariah Compliant',
          'Natural hedge against recession',
        ],
        ytd: 13.12,
        oneYear: 56.47,
        risk: models.Risk.high,
        badges: [
          models.Badge(
            text: 'Top Performing',
            icon: Icons.diamond,
            color: const Color(0xFF0B3A76),
          ),
          models.Badge(
            text: 'Most Popular',
            icon: Icons.local_fire_department,
            color: const Color(0xFFB35C00),
          ),
        ],
        iconBg: const Color(0xFFFFF1D6),
        icon: Icons.inventory_2,
      ),
      models.FundInfo(
        title: 'MHuat Malaysia Bond',
        subtitle: '(AHAM Bond Fund)',
        bullets: const [
          'Bonds as portfolio stabilizer',
          'Monthly income distribution',
          'Medium to long-term investment horizon',
        ],
        ytd: 0.10,
        oneYear: 4.06,
        risk: models.Risk.low,
        badges: [
          models.Badge(
            text: 'Newest Addition',
            icon: Icons.fiber_new,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFDFF3FF),
        icon: Icons.account_balance,
      ),
      models.FundInfo(
        title: 'MHuat China Equity Tracker',
        subtitle: '(AHAM New China Tracker Fund)',
        bullets: const [
          'Exposure to China market',
          'Diversified sector allocation',
          'Medium to long-term investment horizon',
        ],
        ytd: 2.56,
        oneYear: 3.53,
        risk: models.Risk.high,
        badges: [
          models.Badge(
            text: 'Newest Addition',
            icon: Icons.fiber_new,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFFFE0E0),
        icon: Icons.flag,
      ),
      models.FundInfo(
        title: 'MHuat Growth',
        subtitle: '(AHAM Versa Portfolio - Growth)',
        bullets: const [
          'High allocation to equities',
          'Exposure to S&P500',
          'Medium to long-term investment horizon',
        ],
        ytd: 1.30,
        oneYear: 4.67,
        risk: models.Risk.high,
        badges: const [],
        iconBg: const Color(0xFFE6FFF1),
        icon: Icons.park,
      ),
      models.FundInfo(
        title: 'MHuat Global-i',
        subtitle: '(AHAM Aiiman Global Multi Thematic Fund (MYR-Hedged class))',
        bullets: const [
          'High allocation to Technology equities',
          'Shariah Compliant',
          'Medium to long-term investment horizon',
        ],
        ytd: 1.03,
        oneYear: 15.48,
        risk: models.Risk.high,
        badges: const [],
        iconBg: const Color(0xFFE9F3FF),
        icon: Icons.public,
      ),
      models.FundInfo(
        title: 'MHuat Dividend+',
        subtitle: '(AHAM Select Dividend Fund)',
        bullets: const [
          'Regular income distribution',
          'Diversify through Malaysian and Asian investments',
          'Proven track record',
        ],
        ytd: 3.55,
        oneYear: 15.91,
        risk: models.Risk.high,
        badges: const [],
        iconBg: const Color(0xFFFFF0F5),
        icon: Icons.savings,
      ),
      models.FundInfo(
        title: 'MHuat India Equity',
        subtitle: '(AHAM World Series - India Equity Fund (MYR-Hedged class))',
        bullets: const [
          'Exposure to Indian equities',
          'Harness Franklin India Fund strategy to achieve capital growth',
          'Medium to long-term investment horizon',
        ],
        ytd: -6.96,
        oneYear: -0.69,
        risk: models.Risk.high,
        badges: [
          models.Badge(
            text: 'Newest Addition',
            icon: Icons.fiber_new,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFFFF1D6),
        icon: Icons.temple_hindu,
      ),
      models.FundInfo(
        title: 'MHuat Moderate',
        subtitle: '(AHAM Versa Portfolio - Moderate)',
        bullets: const [
          'High allocation to fixed income',
          'Exposure to S&P500',
          'Medium to long-term investment horizon',
        ],
        ytd: 1.15,
        oneYear: 2.40,
        risk: models.Risk.moderate,
        badges: const [],
        iconBg: const Color(0xFFE9FFF6),
        icon: Icons.spa,
      ),
      models.FundInfo(
        title: 'MHuat REITs',
        subtitle: '(AHAM Select Asia Pacific (ex Japan) REITs Fund)',
        bullets: const [
          'Exposure to Singapore, APAC REITs',
          'Highly diversified property portfolio',
          'Medium to long-term investment horizon',
        ],
        ytd: 1.07,
        oneYear: 10.00,
        risk: models.Risk.high,
        badges: const [],
        iconBg: const Color(0xFFEAF2FF),
        icon: Icons.home_work,
      ),
      models.FundInfo(
        title: 'MHuat US-Tech',
        subtitle: '(AHAM World Series - US Technology Fund (MYR class))',
        bullets: const [
          'Invest in leading US tech giants and emerging pioneers',
          'Harness JP Morgan US Technology Strategy to identify new tech leaders',
          'Medium to long-term investment horizon',
        ],
        ytd: -3.66,
        oneYear: 5.36,
        risk: models.Risk.high,
        badges: [
          models.Badge(
            text: 'Newest Addition',
            icon: Icons.fiber_new,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFEFF2FF),
        icon: Icons.memory,
      ),
      models.FundInfo(
        title: 'MHuat Japan',
        subtitle: '(AHAM World Series - Japan Growth Fund (MYR class))',
        bullets: const [
          'Exposure to Japanese equities',
          'Diversified sector allocation',
          'Positive outlook of Japanese Yen (JPY)',
        ],
        ytd: 4.05,
        oneYear: 22.80,
        risk: models.Risk.high,
        badges: const [],
        iconBg: const Color(0xFFE9F7FF),
        icon: Icons.landscape,
      ),
      models.FundInfo(
        title: 'MHuat SGD',
        subtitle: '(AHAM Select SGD Income Fund (MYR class))',
        bullets: const [
          'Exposure to SGD-denominated assets',
          'Regular income distribution',
          'Diversify against MYR depreciation',
        ],
        ytd: 0.39,
        oneYear: 4.35,
        risk: models.Risk.moderate,
        badges: const [],
        iconBg: const Color(0xFFFFF0F0),
        icon: Icons.flag_circle,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemBuilder: (context, index) => _FundCard(info: funds[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: funds.length,
    );
  }
}

class _FundCard extends StatefulWidget {
  final models.FundInfo info;
  const _FundCard({required this.info});

  @override
  State<_FundCard> createState() => _FundCardState();
}

class _FundCardState extends State<_FundCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FundDetailPage(fund: info),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (info.badges.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: info.badges.map((b) => _BadgePill(badge: b)).toList(),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: info.iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    info.icon,
                    size: 28,
                    color: const Color(0xFF0B3A76),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0B3A76),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info.subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...info.bullets.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  iconSize: 24,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MetricCentered(
                    value: _formatPct(info.ytd),
                    label: 'YTD Returns',
                    valueColor: info.ytd < 0
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFF0B3A76),
                  ),
                  _MetricCentered(
                    value: _formatPct(info.oneYear),
                    label: '1Y Return',
                    valueColor: info.oneYear < 0
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFF0B3A76),
                  ),
                  _RiskMetricCentered(risk: info.risk),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPct(double v) {
    final s = v.toStringAsFixed(v.abs() >= 10 ? 2 : 2);
    final cleaned = (double.tryParse(s) ?? v) == 0 ? '0.00' : s;
    return '$cleaned%';
  }
}

class _MetricCentered extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _MetricCentered({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _RiskMetricCentered extends StatelessWidget {
  final models.Risk risk;
  const _RiskMetricCentered({required this.risk});

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (risk) {
      models.Risk.low => ('Low', const Color(0xFF2E7D32)),
      models.Risk.moderate => ('Moderate', const Color(0xFFF9A825)),
      models.Risk.high => ('High', const Color(0xFFD32F2F)),
    };

    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Level',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  final models.Badge badge;
  const _BadgePill({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badge.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: badge.color.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 16, color: badge.color),
          const SizedBox(width: 6),
          Text(
            badge.text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: badge.color,
            ),
          ),
        ],
      ),
    );
  }
}