import 'package:flutter/material.dart';
import 'package:my_huat/core/services/points_service.dart';
import 'package:my_huat/core/services/sound_service.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'investment_basic.dart';
import 'ownership.dart';
import 'lending.dart';

class MyGoalsPage extends StatefulWidget {
  const MyGoalsPage({super.key});

  @override
  State<MyGoalsPage> createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  final PointsService _pointsService = PointsService();
  final SoundService _soundService = SoundService();
  bool _isSoundWorking = false;

  @override
  void initState() {
    super.initState();
    _checkSoundSetup();
  }

  // Check if sound is properly set up
  Future<void> _checkSoundSetup() async {
    final exists = await _soundService.checkSoundFileExists();
    setState(() {
      _isSoundWorking = exists;
    });

    if (!exists) {
      print('⚠️ WARNING: Sound file not found! Make sure assets/sound/sound5.mp3 exists');
    }
  }

  @override
  void dispose() {
    _soundService.dispose();
    super.dispose();
  }

  // Helper method to handle points earned with sound
  Future<void> _handlePointsEarned(int pointsEarned) async {
    if (pointsEarned > 0) {
      // Update points
      setState(() {
        _pointsService.addPoints(pointsEarned);
      });

      // Play sound with better error handling
      try {
        print('🎵 Attempting to play sound for $pointsEarned points...');
        await _soundService.playPointsEarnedSound();
        print('✅ Sound play attempted successfully');
      } catch (e) {
        print('❌ Error playing sound: $e');

        // Show error message to user (optional, remove in production)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sound unavailable: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }

      // Show points earned message
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
      body: Column(
        children: [
          const ArcHeader(title: "MHuat"),

          // Debug banner - REMOVE IN PRODUCTION
          if (!_isSoundWorking)
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.all(8),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sound not configured. Check assets/sound/sound5.mp3',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

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

                const Spacer(),

                // Test sound button - REMOVE IN PRODUCTION

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

                  // Investment Learning Section Title
                  Row(
                    children: [
                      const Text(
                        'Investment Learning',
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
                          Icons.auto_stories,
                          color: const Color(0xFF0D3A6D),
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Investment Basics Card
                  _buildInvestNowStyleCard(
                    title: "Investment Basics",
                    iconData: Icons.trending_up,
                    iconBgColor: const Color(0xFFFFF1D6),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InvestmentBasicPage(),
                        ),
                      );

                      if (result != null && result is int) {
                        await _handlePointsEarned(result);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Ownership Investments Card
                  _buildInvestNowStyleCard(
                    title: "Ownership Investments",
                    iconData: Icons.business_center,
                    iconBgColor: const Color(0xFFDFF3FF),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OwnershipInvestmentsPage(),
                        ),
                      );

                      if (result != null && result is int) {
                        await _handlePointsEarned(result);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Lending & Low-risk Investments Card
                  _buildInvestNowStyleCard(
                    title: "Lending & Low-risk Investments",
                    iconData: Icons.savings,
                    iconBgColor: const Color(0xFFFFE0E0),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LendingInvestmentsPage(),
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

  // Card builder
  Widget _buildInvestNowStyleCard({
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                iconData,
                size: 28,
                color: const Color(0xFF0D3A6D),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}