import 'package:flutter/material.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'risk_assessment_page.dart';

class PortfolioSetupPage extends StatefulWidget {
  const PortfolioSetupPage({super.key});

  @override
  State<PortfolioSetupPage> createState() => _PortfolioSetupPageState();
}

class _PortfolioSetupPageState extends State<PortfolioSetupPage> {
  // Define blue color to match InvestNowPage
  final Color navyBlue = const Color(0xFF0B3A76);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
                    'Portfolio Setup',
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
              child: _PortfolioSetupContent(),
            ),
          ],
        ),
      ),
    );
  }
}

// Portfolio Setup content component
class _PortfolioSetupContent extends StatefulWidget {
  const _PortfolioSetupContent();

  @override
  State<_PortfolioSetupContent> createState() => _PortfolioSetupContentState();
}

class _PortfolioSetupContentState extends State<_PortfolioSetupContent> {
  final Color navyBlue = const Color(0xFF0B3A76);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Build Your Portfolio Card - COLORS SWITCHED
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, // Changed to white background
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: navyBlue, // Changed to blue icon
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Build Your Portfolio',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: navyBlue, // Changed to blue text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'ll help you build your portfolio in just a few steps.',
                    style: TextStyle(
                      fontSize: 16,
                      color: navyBlue.withOpacity(0.8), // Changed to blue text with opacity
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // How It Works Section
            const Text(
              'How It Works',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Step Cards
            _buildStepCard(
              stepNumber: '1',
              title: 'Answer Risk Assessment Questions',
              description: 'Answer a series of risk assessment questions to determine your risk profile and investment preferences.',
              icon: Icons.quiz,
              color: navyBlue.withOpacity(0.1),
              iconColor: navyBlue,
            ),

            const SizedBox(height: 12),

            _buildStepCard(
              stepNumber: '2',
              title: 'Get Your Personalised Portfolio',
              description: 'Receive your personalised investment portfolio based on your risk tolerance and financial goals.',
              icon: Icons.auto_awesome,
              color: navyBlue.withOpacity(0.1),
              iconColor: navyBlue,
            ),

            const SizedBox(height: 12),

            _buildStepCard(
              stepNumber: '3',
              title: 'Sit Back & Relax',
              description: 'Our Robo Investment Advisor automatically grows your wealth while you focus on what matters most.',
              icon: Icons.weekend,
              color: navyBlue.withOpacity(0.1),
              iconColor: navyBlue,
            ),

            const SizedBox(height: 24),

            // Build My Portfolio Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiskAssessmentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Build My Portfolio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Robo Advisor Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: navyBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: navyBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: navyBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Robo Investment Advisor',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Our AI-powered advisor continuously optimizes your portfolio for maximum returns based on market conditions.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Time Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.amber.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This process takes approximately 5-10 minutes to complete.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Number Circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: iconColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}