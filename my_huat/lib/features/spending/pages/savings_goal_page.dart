import 'package:flutter/material.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

class SavingsGoalPage extends StatefulWidget {
  const SavingsGoalPage({super.key});

  @override
  State<SavingsGoalPage> createState() => _SavingsGoalPageState();
}

class _SavingsGoalPageState extends State<SavingsGoalPage> {
  double _monthlyGoal = 500.0;
  final double _currentBalance = 1250.0; // Replace with real data

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
                  'Savings Goal',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Current savings card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.savings, color: const Color(0xFF0D3A6D)),
                              const SizedBox(width: 8),
                              const Text(
                                'Current Savings',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D3A6D),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'RM ${_currentBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D3A6D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Monthly goal card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Savings Goal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D3A6D),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _monthlyGoal,
                                  min: 100,
                                  max: 5000,
                                  divisions: 49,
                                  activeColor: const Color(0xFF1080E7),
                                  inactiveColor: const Color(0xFF7EBEFB),
                                  onChanged: (value) {
                                    setState(() {
                                      _monthlyGoal = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0EDFE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'RM ${_monthlyGoal.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D3A6D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Quick amount chips
                          Row(
                            children: [
                              _buildQuickChip(500),
                              const SizedBox(width: 8),
                              _buildQuickChip(1000),
                              const SizedBox(width: 8),
                              _buildQuickChip(2000),
                              const SizedBox(width: 8),
                              _buildQuickChip(5000),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Monthly goal set to RM ${_monthlyGoal.toStringAsFixed(0)}',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1080E7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'SAVE GOAL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
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

  Widget _buildQuickChip(double amount) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _monthlyGoal = amount),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE0EDFE),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF7EBEFB)),
          ),
          child: Text(
            'RM ${amount.toInt()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0D3A6D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}