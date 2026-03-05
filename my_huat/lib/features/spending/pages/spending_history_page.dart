// lib/features/spending/pages/spending_history_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'record_spending_page.dart';

class SpendingHistoryPage extends StatefulWidget {
  const SpendingHistoryPage({super.key});

  @override
  State<SpendingHistoryPage> createState() => _SpendingHistoryPageState();
}

class _SpendingHistoryPageState extends State<SpendingHistoryPage> {
  // Mock data (we added a few more dates so you can test the range filter)
  final List<Map<String, dynamic>> _allRecords = [
    {'title': 'Chicken Rice', 'amount': 12.00, 'date': DateTime.now(), 'category': 'Food'},
    {'title': 'UTM Shuttle', 'amount': 2.50, 'date': DateTime.now().subtract(const Duration(days: 1)), 'category': 'Transport'},
    {'title': 'Stationery', 'amount': 15.00, 'date': DateTime.now().subtract(const Duration(days: 5)), 'category': 'Shopping'},
    {'title': 'Movie Ticket', 'amount': 20.00, 'date': DateTime.now().subtract(const Duration(days: 10)), 'category': 'Entertainment'},
  ];

  List<Map<String, dynamic>> _displayData = [];
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _displayData = _allRecords; // Show everything initially
  }

  // 🌟 NEW: The Date Range Picker function
  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        // Styling the picker to match MHuat's brand colors
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D3A6D), 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _displayData = _allRecords.where((item) {
          final date = item['date'] as DateTime;
          // Normalize times to midnight to ensure accurate day-to-day comparison
          final recordDate = DateTime(date.year, date.month, date.day);
          final startDate = DateTime(picked.start.year, picked.start.month, picked.start.day);
          final endDate = DateTime(picked.end.year, picked.end.month, picked.end.day);

          return (recordDate.isAtSameMomentAs(startDate) || recordDate.isAfter(startDate)) &&
                 (recordDate.isAtSameMomentAs(endDate) || recordDate.isBefore(endDate));
        }).toList();
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDateRange = null;
      _displayData = _allRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format the text to show in the AppBar if a range is selected
    String headerText = "Spending History";
    if (_selectedDateRange != null) {
      final startStr = DateFormat('dd MMM').format(_selectedDateRange!.start);
      final endStr = DateFormat('dd MMM').format(_selectedDateRange!.end);
      headerText = startStr == endStr ? startStr : "$startStr - $endStr";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          headerText, 
          style: const TextStyle(fontFamily: 'CaveatFont', fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D3A6D),
        foregroundColor: Colors.white,
        actions: [
          // 🌟 Button to open the range picker
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Filter by Date',
            onPressed: _pickDateRange,
          ),
          // Show a clear button only if a filter is currently active
          if (_selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear Filter',
              onPressed: _clearFilter,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _displayData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No records found for this period.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _displayData.length,
              itemBuilder: (context, index) {
                final item = _displayData[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0D3A6D).withOpacity(0.1), 
                      child: const Icon(Icons.receipt_outlined, color: Color(0xFF0D3A6D), size: 22)
                    ),
                    title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(item['date'])),
                    trailing: Text(
                      "- RM ${item['amount'].toStringAsFixed(2)}", 
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecordSpendingPage(existingRecord: item)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}