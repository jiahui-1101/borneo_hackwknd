import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'retirement_page.dart';

class RetirementResultPage extends StatelessWidget {
  final RetirementData data;
  const RetirementResultPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final calculations = _calculateRetirement();
    final Color navyBlue = const Color(0xFF0B3A76);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ArcHeader(title: "MHuat"),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)
                ),
                const SizedBox(width: 8),
                const Text(
                  'Your Retirement Analysis',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B3A76)
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryCard(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildMainResultCard(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildGrowthChart(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildComparisonCard(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildBreakdownCard(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildProjectionTable(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildRecommendationCard(calculations, navyBlue),
                  const SizedBox(height: 20),
                  _buildActionButtons(context, navyBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateRetirement() {
    final yearsToRetirement = data.retirementAge - data.currentAge;
    final monthsToRetirement = yearsToRetirement * 12;
    final monthlyReturnRate = data.expectedReturn / 12;

    // Calculate investment growth with monthly compounding
    double totalSavings = data.currentSavings;
    List<double> yearlyProjection = [data.currentSavings];

    for (int i = 0; i < monthsToRetirement; i++) {
      totalSavings = totalSavings * (1 + monthlyReturnRate) + data.monthlyContribution;

      // Store yearly values for chart
      if ((i + 1) % 12 == 0) {
        yearlyProjection.add(totalSavings);
      }
    }

    // Add EPF if included
    double epfValue = 0;
    if (data.includeEpf && data.epfBalance > 0) {
      final monthlyEpfRate = (data.epfDividendRate / 100) / 12;
      final monthlyEpfContribution = data.currentIncome *
          (data.epfEmployeeRate + data.epfEmployerRate) / 100;

      epfValue = data.epfBalance;
      for (int i = 0; i < monthsToRetirement; i++) {
        epfValue = epfValue * (1 + monthlyEpfRate) + monthlyEpfContribution;
      }
      totalSavings += epfValue;
    }

    // Calculate monthly income (4% rule)
    final monthlyIncome = (totalSavings * 0.04) / 12;
    final incomeRatio = monthlyIncome / data.desiredMonthlyIncome;

    // Calculate with inflation adjustment
    final inflationAdjusted = totalSavings / pow(1 + data.inflationRate, yearsToRetirement);
    final realMonthlyIncome = (inflationAdjusted * 0.04) / 12;

    return {
      'totalSavings': totalSavings,
      'monthlyIncome': monthlyIncome,
      'realMonthlyIncome': realMonthlyIncome,
      'incomeRatio': incomeRatio,
      'yearsToRetirement': yearsToRetirement.toDouble(),
      'yearlyProjection': yearlyProjection,
      'epfValue': epfValue,
      'totalContributions': data.currentSavings + (data.monthlyContribution * monthsToRetirement),
      'investmentGrowth': totalSavings - (data.currentSavings + (data.monthlyContribution * monthsToRetirement)),
    };
  }

  Widget _buildSummaryCard(Map<String, dynamic> calc, Color navyBlue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [navyBlue.withValues(alpha: 0.8), navyBlue]
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Your Retirement Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Current Age:', '${data.currentAge} years', Icons.person),
          _buildSummaryRow('Retirement Age:', '${data.retirementAge} years', Icons.flag),
          _buildSummaryRow('Years to Save:', '${calc['yearsToRetirement'].toInt()} years', Icons.timer),
          _buildSummaryRow('Monthly Contribution:', 'RM ${data.monthlyContribution.toStringAsFixed(2)}', Icons.trending_up),
          _buildSummaryRow('Savings Rate:', '${(data.monthlyContribution / data.currentIncome * 100).toStringAsFixed(1)}%', Icons.pie_chart),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMainResultCard(Map<String, dynamic> calc, Color navyBlue) {
    final monthlyIncome = calc['monthlyIncome'];
    final realMonthlyIncome = calc['realMonthlyIncome'];
    final isOnTrack = monthlyIncome >= data.desiredMonthlyIncome;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text(
            'Projected Retirement Savings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'RM ${(calc['totalSavings']).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: navyBlue,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Monthly Income',
                  'RM ${monthlyIncome.toStringAsFixed(0)}',
                  Icons.money,
                  isOnTrack ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'After Inflation',
                  'RM ${realMonthlyIncome.toStringAsFixed(0)}',
                  Icons.trending_down,
                  Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (data.includeEpf && data.epfBalance > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: navyBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      const Text('EPF Contribution:'),
                    ],
                  ),
                  Text(
                    'RM ${(calc['epfValue']).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildGrowthChart(Map<String, dynamic> calc, Color navyBlue) {
    final yearlyData = calc['yearlyProjection'] as List<double>;
    final yearsToRetirement = calc['yearsToRetirement'].toInt();

    // Create spots for line chart
    List<FlSpot> spots = [];
    for (int i = 0; i < yearlyData.length; i++) {
      spots.add(FlSpot(i.toDouble(), yearlyData[i] / 1000000)); // Convert to millions
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: navyBlue),
              const SizedBox(width: 8),
              const Text(
                'Retirement Savings Growth',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 0.5,
                  verticalInterval: 5,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('RM${value.toInt()}M', style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int year = data.currentAge + value.toInt();
                        if (value.toInt() % 5 == 0) {
                          return Text('Age $year', style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: navyBlue,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: navyBlue.withValues(alpha: 0.1),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Goal line
          if (data.desiredMonthlyIncome > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag, color: Colors.amber.shade800, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Target: Need RM ${(data.desiredMonthlyIncome * 12 / 0.04).toStringAsFixed(0)} total savings to achieve your desired income',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade800),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(Map<String, dynamic> calc, Color navyBlue) {
    final ratio = calc['incomeRatio'];
    final isOnTrack = ratio >= 1.0;
    final percentage = (ratio * 100).clamp(0, 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOnTrack ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnTrack ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isOnTrack ? Icons.check_circle : Icons.warning,
                color: isOnTrack ? Colors.green : Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOnTrack ? 'You\'re On Track!' : 'Adjustment Needed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isOnTrack ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                    ),
                    Text(
                      isOnTrack
                          ? 'Your projected income exceeds your goal'
                          : 'Your projected income is $percentage% of your goal',
                      style: TextStyle(
                        fontSize: 14,
                        color: isOnTrack ? Colors.green.shade700 : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress to Goal', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text('$percentage%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio > 1 ? 1 : ratio,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(isOnTrack ? Colors.green : Colors.orange),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(Map<String, dynamic> calc, Color navyBlue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: navyBlue),
              const SizedBox(width: 8),
              const Text('Financial Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          _buildBreakdownItem(
            'Total Savings:',
            'RM ${(calc['totalSavings']).toStringAsFixed(2)}',
            navyBlue,
          ),
          const Divider(height: 24),

          _buildBreakdownItem(
            'Your Contributions:',
            'RM ${(calc['totalContributions']).toStringAsFixed(2)}',
            Colors.grey.shade700,
          ),
          _buildBreakdownItem(
            'Investment Growth:',
            'RM ${(calc['investmentGrowth']).toStringAsFixed(2)}',
            Colors.green.shade700,
          ),

          const Divider(height: 24),

          _buildBreakdownItem(
            'Goal Monthly Income:',
            'RM ${data.desiredMonthlyIncome.toStringAsFixed(2)}',
            navyBlue,
            isBold: true,
          ),
          _buildBreakdownItem(
            'Projected Monthly Income:',
            'RM ${calc['monthlyIncome'].toStringAsFixed(2)}',
            calc['incomeRatio'] >= 1 ? Colors.green : Colors.orange,
            isBold: true,
          ),
          _buildBreakdownItem(
            'Monthly Expenses:',
            'RM ${data.monthlyExpenses.toStringAsFixed(2)}',
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectionTable(Map<String, dynamic> calc, Color navyBlue) {
    final yearlyData = calc['yearlyProjection'] as List<double>;
    final yearsToRetirement = calc['yearsToRetirement'].toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.table_chart, color: navyBlue),
              const SizedBox(width: 8),
              const Text('Year-by-Year Projection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text('Age', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue))),
                Expanded(child: Text('Savings (RM)', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue))),
              ],
            ),
          ),

          // Table rows - show every 5 years
          ...List.generate((yearlyData.length / 5).ceil(), (index) {
            final yearIndex = index * 5;
            if (yearIndex >= yearlyData.length) return const SizedBox.shrink();

            final age = data.currentAge + yearIndex;
            final savings = yearlyData[yearIndex];

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text('$age')),
                  Expanded(child: Text('${savings.toStringAsFixed(0)}')),
                ],
              ),
            );
          }),

          // Final year
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: Text('${data.retirementAge}', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('${(calc['totalSavings']).toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> calc, Color navyBlue) {
    final ratio = calc['incomeRatio'];
    final savingsRate = data.monthlyContribution / data.currentIncome * 100;
    final shortfall = data.desiredMonthlyIncome - calc['monthlyIncome'];
    final additionalNeeded = shortfall > 0 ? (shortfall * 12 / 0.04) : 0;

    List<Map<String, dynamic>> recommendations = [];

    if (ratio < 0.7) {
      recommendations.add({
        'icon': Icons.warning,
        'text': 'Critical: You need to significantly increase your savings',
        'color': Colors.red,
      });
    } else if (ratio < 1.0) {
      recommendations.add({
        'icon': Icons.info,
        'text': 'You need an additional RM ${additionalNeeded.toStringAsFixed(0)} in savings to reach your goal',
        'color': Colors.orange,
      });
    }

    if (savingsRate < 15) {
      recommendations.add({
        'icon': Icons.trending_up,
        'text': 'Increase your savings rate to 15-20% of income (currently ${savingsRate.toStringAsFixed(1)}%)',
        'color': navyBlue,
      });
    }

    if (data.includeEpf && data.epfBalance == 0) {
      recommendations.add({
        'icon': Icons.account_balance,
        'text': 'Consider including EPF savings in your calculation',
        'color': navyBlue,
      });
    }

    recommendations.addAll([
      {
        'icon': Icons.calendar_today,
        'text': 'Review your retirement plan annually',
        'color': Colors.grey.shade700,
      },
      {
        'icon': Icons.support_agent,
        'text': 'Consult a financial advisor for personalized advice',
        'color': Colors.grey.shade700,
      },
    ]);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navyBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navyBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: navyBlue, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map((rec) => _buildRecommendationItem(
            rec['text'],
            rec['icon'],
            rec['color'],
          )),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color navyBlue) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: navyBlue,
              side: BorderSide(color: navyBlue.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Adjust Inputs'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showSaveDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: navyBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save Results'),
          ),
        ),
      ],
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Results'),
        content: const Text('Your retirement plan has been saved to your profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}