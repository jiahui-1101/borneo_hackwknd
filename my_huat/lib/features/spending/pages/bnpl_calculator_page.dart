// lib/features/spending/pages/bnpl_calculator_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

class BnplCalculatorPage extends StatefulWidget {
  const BnplCalculatorPage({super.key});

  @override
  State<BnplCalculatorPage> createState() => _BnplCalculatorPageState();
}

class _BnplCalculatorPageState extends State<BnplCalculatorPage> {
  final TextEditingController _purchaseController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _lateRepaymentsController = TextEditingController();

  double purchaseAmount = 0;
  double bnplRate = 0;
  int lateRepayments = 0;
  double totalCost = 0;
  String aiSuggestion = "";
  String suitabilityScore = "";
  String recommendationType = "neutral";

  // Light purple color using purple.shade800
  final Color lightPurple = Colors.purple.shade800;

  // Typical BNPL late fees (can be adjusted)
  final double lateFeePerOccurrence = 15.0; // RM15 per late payment

  void _calculateTotalCost() {
    setState(() {
      purchaseAmount = double.tryParse(_purchaseController.text) ?? 0;
      bnplRate = double.tryParse(_rateController.text) ?? 0;
      lateRepayments = int.tryParse(_lateRepaymentsController.text) ?? 0;

      // Calculate total cost including interest and late fees
      double interestAmount = purchaseAmount * (bnplRate / 100);
      double lateFees = lateRepayments * lateFeePerOccurrence;
      totalCost = purchaseAmount + interestAmount + lateFees;

      _generateEnhancedAISuggestion();
    });
  }

  void _generateEnhancedAISuggestion() {
    if (purchaseAmount == 0) {
      aiSuggestion = "Please enter your purchase amount to get personalized BNPL advice.";
      suitabilityScore = "N/A";
      recommendationType = "neutral";
      return;
    }

    double interestAmount = purchaseAmount * (bnplRate / 100);
    double lateFees = lateRepayments * lateFeePerOccurrence;
    double totalFees = totalCost - purchaseAmount;
    double feePercentage = (totalFees / purchaseAmount) * 100;

    StringBuffer suggestion = StringBuffer();

    // Calculate suitability score (0-100)
    int score = 100;
    List<String> pros = [];
    List<String> cons = [];

    // Analyze based on interest rate
    if (bnplRate == 0) {
      pros.add("• 0% interest - You're paying no extra for financing");
      score -= 0;
    } else if (bnplRate <= 5) {
      pros.add("• Low interest rate (${bnplRate}%) - Reasonable financing cost");
      score -= 5;
    } else if (bnplRate <= 10) {
      cons.add("• Moderate interest rate (${bnplRate}%) - Consider if you really need financing");
      score -= 15;
    } else if (bnplRate <= 15) {
      cons.add("• High interest rate (${bnplRate}%) - This will significantly increase your cost");
      score -= 25;
    } else {
      cons.add("• Very high interest rate (${bnplRate}%) - Strongly consider alternatives");
      score -= 35;
    }

    // Analyze based on late payments
    if (lateRepayments == 0) {
      pros.add("• No late payments - Good payment history");
      score -= 0;
    } else if (lateRepayments == 1) {
      cons.add("• 1 late payment - Cost you RM$lateFeePerOccurrence in fees");
      score -= 15;
    } else if (lateRepayments <= 3) {
      cons.add("• $lateRepayments late payments - Accumulating RM${lateFees.toStringAsFixed(2)} in penalties");
      score -= 25;
    } else {
      cons.add("• $lateRepayments late payments - This is becoming a costly habit (RM${lateFees.toStringAsFixed(2)})");
      score -= 40;
    }

    // Analyze based on purchase amount
    if (purchaseAmount < 100) {
      cons.add("• Small purchase amount - BNPL might encourage unnecessary spending on small items");
      score -= 10;
    } else if (purchaseAmount > 1000) {
      pros.add("• Large purchase - BNPL helps manage cash flow for big expenses");
      score -= 0;
    }

    // Analyze based on total fees percentage
    if (feePercentage == 0) {
      pros.add("• No additional fees - You're paying exactly the purchase price");
    } else if (feePercentage <= 5) {
      pros.add("• Low fee percentage (${feePercentage.toStringAsFixed(1)}%) - Minimal impact on total cost");
    } else if (feePercentage <= 10) {
      cons.add("• Moderate fee percentage (${feePercentage.toStringAsFixed(1)}%) - Consider if the convenience is worth it");
    } else {
      cons.add("• High fee percentage (${feePercentage.toStringAsFixed(1)}%) - This is significantly increasing your cost");
    }

    // Ensure score is within bounds
    score = score.clamp(0, 100);

    // Determine suitability and recommendation type
    if (score >= 80) {
      suitabilityScore = "EXCELLENT (${score}/100)";
      recommendationType = "excellent";
    } else if (score >= 60) {
      suitabilityScore = "GOOD (${score}/100)";
      recommendationType = "good";
    } else if (score >= 40) {
      suitabilityScore = "FAIR (${score}/100)";
      recommendationType = "fair";
    } else {
      suitabilityScore = "POOR (${score}/100)";
      recommendationType = "poor";
    }

    // Build the AI suggestion text
    suggestion.writeln("📊 BNPL SUITABILITY ANALYSIS\n");

    // Overall recommendation based on score
    if (score >= 80) {
      suggestion.writeln("✅ HIGHLY SUITABLE: This BNPL plan works well for your situation!\n");
    } else if (score >= 60) {
      suggestion.writeln("👍 SUITABLE: This BNPL plan is acceptable for your needs.\n");
    } else if (score >= 40) {
      suggestion.writeln("⚠️ USE WITH CAUTION: This BNPL plan has some drawbacks.\n");
    } else {
      suggestion.writeln("❌ NOT RECOMMENDED: Consider alternatives to BNPL.\n");
    }

    // Pros section
    if (pros.isNotEmpty) {
      suggestion.writeln("✅ ADVANTAGES:");
      for (var pro in pros) {
        suggestion.writeln(pro);
      }
      suggestion.writeln("");
    }

    // Cons section
    if (cons.isNotEmpty) {
      suggestion.writeln("⚠️ DISADVANTAGES:");
      for (var con in cons) {
        suggestion.writeln(con);
      }
      suggestion.writeln("");
    }

    // Cost analysis
    suggestion.writeln("💰 COST BREAKDOWN:");
    suggestion.writeln("• Purchase amount: RM${purchaseAmount.toStringAsFixed(2)}");
    if (interestAmount > 0) {
      suggestion.writeln("• Interest cost: RM${interestAmount.toStringAsFixed(2)}");
    }
    if (lateFees > 0) {
      suggestion.writeln("• Late fees: RM${lateFees.toStringAsFixed(2)}");
    }
    suggestion.writeln("• TOTAL COST: RM${totalCost.toStringAsFixed(2)}");
    if (totalFees > 0) {
      suggestion.writeln("• You're paying RM${totalFees.toStringAsFixed(2)} extra (${feePercentage.toStringAsFixed(1)}% above purchase price)");
    }
    suggestion.writeln("");

    // Alternative recommendations
    suggestion.writeln("💡 RECOMMENDATIONS:");
    if (bnplRate > 10) {
      suggestion.writeln("• Consider using a debit card or savings instead of high-interest BNPL");
    }
    if (lateRepayments > 0) {
      suggestion.writeln("• Set up automatic payments to avoid future late fees");
      suggestion.writeln("• Add payment reminders to your calendar");
    }
    if (purchaseAmount < 100 && bnplRate > 0) {
      suggestion.writeln("• For small purchases, consider paying upfront to avoid interest");
    }
    if (totalFees > purchaseAmount * 0.1) {
      suggestion.writeln("• The fees (${feePercentage.toStringAsFixed(1)}%) are quite high - explore other financing options");
    }
    if (lateRepayments == 0 && bnplRate == 0) {
      suggestion.writeln("• You're using BNPL optimally! Just maintain your good payment habits");
    }

    // Final verdict
    suggestion.writeln("\n📋 FINAL VERDICT: ${_getVerdict(score)}");

    aiSuggestion = suggestion.toString();
  }

  String _getVerdict(int score) {
    if (score >= 80) {
      return "BNPL is an excellent choice for this purchase. The terms are favorable and you're managing it well.";
    } else if (score >= 60) {
      return "BNPL is acceptable, but review the disadvantages above to optimize your usage.";
    } else if (score >= 40) {
      return "BNPL has significant drawbacks in your case. Consider if the convenience outweighs the costs.";
    } else {
      return "BNPL is not recommended. The costs outweigh the benefits. Look for alternative payment methods.";
    }
  }

  List<BarChartGroupData> _generateChartData() {
    if (purchaseAmount == 0) return [];

    double interestAmount = purchaseAmount * (bnplRate / 100);
    double lateFees = lateRepayments * lateFeePerOccurrence;

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: purchaseAmount,
            color: Colors.blue,
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: interestAmount,
            color: Colors.orange,
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: lateFees,
            color: Colors.red,
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Arc Header with MHuat text
          const ArcHeader(title: "MHuat"),

          // Title Section with Back Arrow
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                // Back arrow
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title
                const Text(
                  "BNPL Calculator",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _purchaseController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Purchase Amount (RM)",
                                labelStyle: TextStyle(color: Colors.grey.shade600),
                                border: const OutlineInputBorder(),
                                prefixIcon: Icon(Icons.shopping_cart, color: Colors.grey.shade600),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightPurple, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightPurple.withOpacity(0.5), width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _rateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "BNPL Rate (%)",
                                labelStyle: TextStyle(color: Colors.grey.shade600),
                                border: const OutlineInputBorder(),
                                prefixIcon: Icon(Icons.percent, color: Colors.grey.shade600),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightPurple, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightPurple.withOpacity(0.5), width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _lateRepaymentsController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Number of Late Repayments",
                                labelStyle: TextStyle(color: Colors.grey.shade600),
                                border: const OutlineInputBorder(),
                                prefixIcon: Icon(Icons.warning, color: Colors.grey.shade600),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightPurple, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightPurple.withOpacity(0.5), width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Larger Calculate Button - Light Purple
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _calculateTotalCost,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: lightPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  "CALCULATE TOTAL COST",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Results Section
                    if (purchaseAmount > 0) ...[
                      // Suitability Score Card - White background with grey text
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                size: 40,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "BNPL Suitability Score",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      suitabilityScore,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cost Breakdown Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Total Cost Breakdown",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildResultRow("Purchase Amount:",
                                  "RM${purchaseAmount.toStringAsFixed(2)}", Colors.blue),
                              _buildResultRow("Interest (${bnplRate}%):",
                                  "RM${(purchaseAmount * bnplRate / 100).toStringAsFixed(2)}", Colors.orange),
                              _buildResultRow("Late Fees:",
                                  "RM${(lateRepayments * lateFeePerOccurrence).toStringAsFixed(2)}", Colors.red),
                              Divider(height: 24, color: Colors.grey.shade300),
                              _buildResultRow("TOTAL COST:",
                                  "RM${totalCost.toStringAsFixed(2)}", Colors.green, isBold: true),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Graph Section
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Cost Breakdown Chart",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 250,
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: totalCost,
                                    gridData: const FlGridData(show: false),
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.grey.shade800,
                                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                          String label;
                                          switch (group.x) {
                                            case 0:
                                              label = "Purchase";
                                              break;
                                            case 1:
                                              label = "Interest";
                                              break;
                                            case 2:
                                              label = "Late Fees";
                                              break;
                                            default:
                                              label = "";
                                          }
                                          return BarTooltipItem(
                                            '$label\nRM${rod.toY.toStringAsFixed(2)}',
                                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            switch (value.toInt()) {
                                              case 0:
                                                return Text('Purchase',
                                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500));
                                              case 1:
                                                return Text('Interest',
                                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500));
                                              case 2:
                                                return Text('Late Fees',
                                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500));
                                              default:
                                                return const Text('');
                                            }
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 45,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              'RM${value.toInt()}',
                                              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                                            );
                                          },
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    barGroups: _generateChartData(),
                                  ),
                                ),
                              ),
                              // Legend
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildLegendItem('Purchase', Colors.blue),
                                    _buildLegendItem('Interest', Colors.orange),
                                    _buildLegendItem('Late Fees', Colors.red),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // AI Suggestion Section - White background with grey text
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                      Icons.auto_awesome,
                                      color: Colors.grey.shade700,
                                      size: 28
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "AI-Powered BNPL Analysis",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  aiSuggestion,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade900,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey.shade700,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: isBold ? 18 : 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _purchaseController.dispose();
    _rateController.dispose();
    _lateRepaymentsController.dispose();
    super.dispose();
  }
}