import 'package:flutter/material.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'package:my_huat/core/services/points_service.dart';
import 'package:my_huat/core/services/sound_service.dart';

// Import insurance pages (you'll need to create these)
import 'insurance_basic.dart';
import 'types_of_insurance.dart';
import 'protection_plans.dart';
import 'policy_types.dart';

class MyGoalsPage extends StatefulWidget {
  const MyGoalsPage({super.key});

  @override
  State<MyGoalsPage> createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  final PointsService _pointsService = PointsService();
  final SoundService _soundService = SoundService();

  @override
  void dispose() {
    _soundService.dispose();
    super.dispose();
  }

  // Helper method to handle points earned with sound
  Future<void> _handlePointsEarned(int pointsEarned) async {
    if (pointsEarned > 0) {
      setState(() {
        _pointsService.addPoints(pointsEarned);
      });

      await _soundService.playPointsEarnedSound();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.stars, color: Colors.yellow),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '🎉 You earned $pointsEarned points!',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF0D3A6D),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          const ArcHeader(title: "MHuat"),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "My Goals",
                  style: TextStyle(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rewards Section Card
                  _buildRewardsCard(),

                  const SizedBox(height: 30),

                  // Insurance Learning Section Title
                  Row(
                    children: [
                      const Text(
                        'Insurance Learning',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D3A6D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D3A6D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.security,
                          color: const Color(0xFF0D3A6D),
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Insurance Basics Card
                  _buildInsuranceStyleCard(
                    title: "Insurance Basics",
                    iconData: Icons.school,
                    iconBgColor: const Color(0xFFFFF1D6),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InsuranceBasicPage(),
                        ),
                      );

                      if (result != null && result is int) {
                        await _handlePointsEarned(result);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Types of Insurance Card
                  _buildInsuranceStyleCard(
                    title: "Types of Insurance",
                    iconData: Icons.category,
                    iconBgColor: const Color(0xFFDFF3FF),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TypesOfInsurancePage(),
                        ),
                      );

                      if (result != null && result is int) {
                        await _handlePointsEarned(result);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Insurance Protection Plans Card
                  _buildInsuranceStyleCard(
                    title: "Insurance Protection Plans",
                    iconData: Icons.shield,
                    iconBgColor: const Color(0xFFFFE0E0),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProtectionPlansPage(),
                        ),
                      );

                      if (result != null && result is int) {
                        await _handlePointsEarned(result);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Insurance Policy Types Card
                  _buildInsuranceStyleCard(
                    title: "Insurance Policy Types",
                    iconData: Icons.description,
                    iconBgColor: const Color(0xFFE6FFF1),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PolicyTypesPage(),
                        ),
                      );

                      if (result != null && result is int) {
                        await _handlePointsEarned(result);
                      }
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rewards card widget
  Widget _buildRewardsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.card_giftcard,
                color: const Color(0xFF0D3A6D),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                "Rewards Available",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D3A6D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF0D3A6D).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monetization_on,
              size: 60,
              color: const Color(0xFF0D3A6D),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "${_pointsService.points} Points",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.normal,
              color: Color(0xFF0D3A6D),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0D3A6D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "1 point = RM0.10 cashback",
              style: TextStyle(
                color: Color(0xFF0D3A6D),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card builder for insurance learning
  Widget _buildInsuranceStyleCard({
    required String title,
    required IconData iconData,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  iconData,
                  size: 28,
                  color: const Color(0xFF0D3A6D),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D3A6D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // "Start Learning" button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D3A6D).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFF0D3A6D).withOpacity(0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: 16,
                          color: const Color(0xFF0D3A6D),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Start Learning",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF0D3A6D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Center(
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}