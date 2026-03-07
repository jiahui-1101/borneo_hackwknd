import 'package:flutter/material.dart';
import '../../../shared/widgets/arc_header.dart';
import '../../../shared/models/insurance_model.dart';
import 'insurance_detail_page.dart';

class PurchaseNowPage extends StatefulWidget {
  const PurchaseNowPage({super.key});

  @override
  State<PurchaseNowPage> createState() => _PurchaseNowPageState();
}

class _PurchaseNowPageState extends State<PurchaseNowPage> {
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
                  'Purchase Now',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _PurchasePortfolioView(),
          ),
        ],
      ),
    );
  }
}

class _PurchasePortfolioView extends StatefulWidget {
  const _PurchasePortfolioView();

  @override
  State<_PurchasePortfolioView> createState() => _PurchasePortfolioViewState();
}

class _PurchasePortfolioViewState extends State<_PurchasePortfolioView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Column(
        children: [
          Expanded(child: _PurchaseList()),
        ],
      ),
    );
  }
}

class _PurchaseList extends StatelessWidget {
  const _PurchaseList();

  @override
  Widget build(BuildContext context) {
    final insuranceProducts = <InsuranceInfo>[
      InsuranceInfo(
        title: 'LifeSecure Pro',
        subtitle: '(Whole Life Insurance)',
        bullets: const [
          'Lifetime coverage',
          'Cash value accumulation',
          'Flexible premium payment',
        ],
        premium: 2400,
        coverage: 200000,
        term: 'Lifetime',
        badges: [
          InsuranceBadge(
            text: 'Best Seller',
            icon: Icons.star,
            color: const Color(0xFF0B3A76),
          ),
          InsuranceBadge(
            text: 'Limited Offer',
            icon: Icons.local_offer,
            color: const Color(0xFFB35C00),
          ),
        ],
        iconBg: const Color(0xFFFFF1D6),
        icon: Icons.favorite,
      ),
      InsuranceInfo(
        title: 'MediShield Plus',
        subtitle: '(Medical & Health Insurance)',
        bullets: const [
          'Inpatient & outpatient coverage',
          'Annual limit up to RM 1M',
          'No co-payment',
        ],
        premium: 1800,
        coverage: 1000000,
        term: 'Annual renewable',
        badges: [
          InsuranceBadge(
            text: 'New',
            icon: Icons.fiber_new,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFDFF3FF),
        icon: Icons.local_hospital,
      ),
      InsuranceInfo(
        title: 'RetireEasy Annuity',
        subtitle: '(Retirement Plan)',
        bullets: const [
          'Guaranteed monthly payout',
          'Tax relief available',
          'Retirement age 55/60',
        ],
        premium: 6000,
        coverage: 300000,
        term: 'Until age 85',
        badges: [
          InsuranceBadge(
            text: 'Top Rated',
            icon: Icons.thumb_up,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFE6FFF1),
        icon: Icons.park,
      ),
      InsuranceInfo(
        title: 'TermGuard',
        subtitle: '(Term Life Insurance)',
        bullets: const [
          'Pure protection, low cost',
          'Choice of 10/20/30 years',
          'Convertible to whole life',
        ],
        premium: 1200,
        coverage: 500000,
        term: '20 years',
        badges: const [],
        iconBg: const Color(0xFFE9F3FF),
        icon: Icons.shield,
      ),
      InsuranceInfo(
        title: 'InvestLink Elite',
        subtitle: '(Investment-Linked Plan)',
        bullets: const [
          'Protection + investment',
          'Unit fund choices',
          'Partial withdrawal allowed',
        ],
        premium: 3600,
        coverage: 150000,
        term: 'Lifetime',
        badges: [
          InsuranceBadge(
            text: 'Flexible',
            icon: Icons.tune,
            color: const Color(0xFF0B3A76),
          ),
        ],
        iconBg: const Color(0xFFFFE0E0),
        icon: Icons.trending_up,
      ),
      InsuranceInfo(
        title: 'CriticalCare',
        subtitle: '(Critical Illness Cover)',
        bullets: const [
          'Lump sum on diagnosis',
          'Covers 36 illnesses',
          'Survival benefit',
        ],
        premium: 2200,
        coverage: 200000,
        term: 'To age 70',
        badges: const [],
        iconBg: const Color(0xFFEAF2FF),
        icon: Icons.healing,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemBuilder: (context, index) =>
          _InsuranceCard(info: insuranceProducts[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: insuranceProducts.length,
    );
  }
}

class _InsuranceCard extends StatefulWidget {
  final InsuranceInfo info;
  const _InsuranceCard({required this.info});

  @override
  State<_InsuranceCard> createState() => _InsuranceCardState();
}

class _InsuranceCardState extends State<_InsuranceCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InsuranceDetailPage(insurance: info),
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
                  _InsuranceMetricCentered(
                    value: _formatCurrency(info.premium, perYear: true),
                    label: 'Premium',
                    valueColor: const Color(0xFF0B3A76),
                  ),
                  _InsuranceMetricCentered(
                    value: _formatCurrency(info.coverage),
                    label: 'Coverage',
                    valueColor: const Color(0xFF0B3A76),
                  ),
                  _TermMetricCentered(term: info.term),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}

class _InsuranceMetricCentered extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _InsuranceMetricCentered({
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

class _TermMetricCentered extends StatelessWidget {
  final String term;
  const _TermMetricCentered({required this.term});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          term,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0B3A76),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Term',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  final InsuranceBadge badge;
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