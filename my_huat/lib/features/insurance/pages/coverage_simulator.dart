import 'dart:math'; // <-- ADD THIS IMPORT
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'package:my_huat/shared/models/fund_type.dart';
import 'package:my_huat/features/insurance/pages/PurchaseNowPage.dart';

class CoverageSimulatorPage extends StatefulWidget {
  final double insuranceAmount;

  const CoverageSimulatorPage({super.key, required this.insuranceAmount});

  @override
  State<CoverageSimulatorPage> createState() => _CoverageSimulatorPageState();
}

class _CoverageSimulatorPageState extends State<CoverageSimulatorPage> {
  final List<Map<String, dynamic>> _disasterTypes = [
    {'name': 'Flood', 'baseCost': 30000.0, 'icon': Icons.water_drop},
    {'name': 'Fire', 'baseCost': 50000.0, 'icon': Icons.local_fire_department},
    {'name': 'Theft', 'baseCost': 10000.0, 'icon': Icons.lock},
    {'name': 'Medical Emergency', 'baseCost': 20000.0, 'icon': Icons.medical_services},
    {'name': 'Car Accident', 'baseCost': 15000.0, 'icon': Icons.car_crash},
  ];

  late Map<String, dynamic> _selectedDisaster;
  int _selectedYear = DateTime.now().year;
  final double _inflationRate = 0.03;

  late double _estimatedCost;
  final Color navyBlue = const Color(0xFF0D3A6D);

  @override
  void initState() {
    super.initState();
    _selectedDisaster = _disasterTypes.first;
    _calculateEstimatedCost();
  }

  void _calculateEstimatedCost() {
    int yearsFromNow = _selectedYear - DateTime.now().year;
    // Use pow from dart:math
    double futureCost = _selectedDisaster['baseCost'] *
        pow(1 + _inflationRate, yearsFromNow).toDouble();
    setState(() {
      _estimatedCost = futureCost;
    });
  }

  bool get _isCovered => widget.insuranceAmount >= _estimatedCost;
  double get _shortfall => _estimatedCost - widget.insuranceAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ArcHeader(title: "MHuat"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  "Coverage Simulator",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyField(
                    icon: Icons.account_balance_wallet,
                    label: 'Your current insurance',
                    value: 'RM ${widget.insuranceAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Disaster Type',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedDisaster,
                    items: _disasterTypes.map((d) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: d,
                        child: Row(
                          children: [
                            Icon(d['icon'], size: 20, color: navyBlue),
                            const SizedBox(width: 8),
                            Text(d['name']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDisaster = val!;
                        _calculateEstimatedCost();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Year of Disaster',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: navyBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _selectedYear.toString(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Slider(
                    value: _selectedYear.toDouble(),
                    min: DateTime.now().year.toDouble(),
                    max: (DateTime.now().year + 10).toDouble(),
                    divisions: 10,
                    activeColor: navyBlue,
                    inactiveColor: navyBlue.withOpacity(0.2),
                    onChanged: (val) {
                      setState(() {
                        _selectedYear = val.round();
                        _calculateEstimatedCost();
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  _buildReadOnlyField(
                    icon: Icons.trending_up,
                    label: 'Estimated loss in $_selectedYear',
                    value: 'RM ${_estimatedCost.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isCovered ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isCovered ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isCovered ? Icons.check_circle : Icons.error,
                              color: _isCovered ? Colors.green[700] : Colors.red[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isCovered ? 'You are covered!' : 'Coverage gap detected',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isCovered ? Colors.green[800] : Colors.red[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isCovered)
                          const Text(
                            'Your current insurance is sufficient for this scenario.',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          )
                        else ...[
                          Text(
                            'Shortfall: RM ${_shortfall.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Recommendation: Consider purchasing additional coverage.',
                            style: TextStyle(fontSize: 14, color: Colors.red[800]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (!_isCovered)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PurchaseNowPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'PURCHASE MORE INSURANCE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildReadOnlyField({required IconData icon, required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: navyBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D3A6D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required Map<String, dynamic> value,
    required List<DropdownMenuItem<Map<String, dynamic>>> items,
    required void Function(Map<String, dynamic>?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, dynamic>>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}