import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'record_spending_page.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

class SpendingHistoryPage extends StatefulWidget {
  const SpendingHistoryPage({super.key});

  @override
  State<SpendingHistoryPage> createState() => _SpendingHistoryPageState();
}

class _SpendingHistoryPageState extends State<SpendingHistoryPage> {
  final Color navyBlue = const Color(0xFF0D3A6D);

  // Mock data for your Borneo HackWKND demo
  final List<Map<String, dynamic>> _allRecords = [
    {'title': 'Chicken Rice', 'amount': 12.00, 'date': DateTime.now(), 'category': 'Food'},
    {'title': 'UTM Shuttle', 'amount': 2.50, 'date': DateTime.now().subtract(const Duration(days: 1)), 'category': 'Transport'},
    {'title': 'Stationery', 'amount': 15.00, 'date': DateTime(2026, 2, 20), 'category': 'Shopping'},
    {'title': 'Movie Ticket', 'amount': 20.00, 'date': DateTime(2025, 12, 10), 'category': 'Entertainment'},
  ];

  List<Map<String, dynamic>> _displayData = [];
  String _filterMode = 'Day'; // Options: 'Day', 'Month', 'Year'
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  // 🌟 FIX: The missing getter that caused your error
  double get _totalSpent => _displayData.fold(0.0, (sum, item) => sum + (item['amount'] as double));

  // 🌟 Filter Logic: Handles Day, Month, and Year manual selection
  void _applyFilter() {
    setState(() {
      _displayData = _allRecords.where((item) {
        final d = item['date'] as DateTime;
        if (_filterMode == 'Day') {
          return d.year == _selectedDate.year && d.month == _selectedDate.month && d.day == _selectedDate.day;
        } else if (_filterMode == 'Month') {
          return d.year == _selectedDate.year && d.month == _selectedDate.month;
        } else if (_filterMode == 'Year') {
          return d.year == _selectedDate.year;
        }
        return true;
      }).toList();
    });
  }

  // 🌟 Manual Date Picker: Customized based on filter mode
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: _filterMode == 'Year' ? DatePickerMode.year : DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: navyBlue,
              onPrimary: Colors.white,
              onSurface: navyBlue,
            ),
            datePickerTheme: const DatePickerThemeData(
              headerBackgroundColor: Colors.white,
              headerForegroundColor: Color(0xFF0D3A6D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _applyFilter();
      });
    }
  }

  BoxDecoration _softModuleDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black.withOpacity(0.04), width: 1), 
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 8), blurRadius: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateLabel = DateFormat('dd MMM yyyy').format(_selectedDate);
    if (_filterMode == 'Month') dateLabel = DateFormat('MMMM yyyy').format(_selectedDate);
    if (_filterMode == 'Year') dateLabel = DateFormat('yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          ArcHeader(title: "MHuat"),
          
          // 1. Navigation & Mode Selection Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                const Spacer(),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(20),
                  selectedColor: Colors.white,
                  fillColor: navyBlue,
                  constraints: const BoxConstraints(minHeight: 32, minWidth: 60),
                  isSelected: [_filterMode == 'Day', _filterMode == 'Month', _filterMode == 'Year'],
                  onPressed: (index) {
                    setState(() {
                      if (index == 0) _filterMode = 'Day';
                      if (index == 1) _filterMode = 'Month';
                      if (index == 2) _filterMode = 'Year';
                      _applyFilter();
                    });
                  },
                  children: const [Text("Day"), Text("Month"), Text("Year")],
                ),
              ],
            ),
          ),

          // 2. Clickable Date Trigger
          _buildDateSelector(dateLabel),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              child: Column(
                children: [
                  // 3. Transactions Module
                  Container(
                    width: double.infinity,
                    decoration: _softModuleDecoration(),
                    child: _displayData.isEmpty 
                      ? const Padding(padding: EdgeInsets.all(50), child: Center(child: Text("No records found.")))
                      : Column(
                          children: _displayData.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var item = entry.value;
                            return Column(
                              children: [
                                _buildTransactionTile(item),
                                if (idx != _displayData.length - 1)
                                  Divider(color: Colors.grey.withOpacity(0.08), height: 1, indent: 20, endIndent: 20),
                              ],
                            );
                          }).toList(),
                        ),
                  ),
                  const SizedBox(height: 24),
                  // 4. Total Card using _totalSpent
                  _buildTotalCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(String label) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: _softModuleDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Selected $_filterMode:", style: TextStyle(color: Colors.grey[600])),
            Row(
              children: [
                Text(label, style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                Icon(Icons.edit_calendar, color: navyBlue, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _softModuleDecoration(color: navyBlue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${_filterMode.toUpperCase()} TOTAL", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
          Text("RM ${_totalSpent.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> item) {
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecordSpendingPage(existingRecord: item))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(radius: 18, backgroundColor: navyBlue.withOpacity(0.04), child: Icon(_getCategoryIcon(item['category']), color: navyBlue, size: 18)),
      title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(DateFormat('dd MMM yyyy').format(item['date']), style: TextStyle(color: Colors.grey[500])),
      trailing: Text("RM ${item['amount'].toStringAsFixed(2)}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Food': return Icons.restaurant_rounded;
      case 'Transport': return Icons.directions_car_rounded;
      case 'Shopping': return Icons.shopping_bag_rounded;
      default: return Icons.receipt_long_rounded;
    }
  }
}