// lib/shared/data_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  static List<Map<String, dynamic>> allRecords = [];

  
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('spending_records');
    
    if (savedData != null && savedData != '[]') {
      final List<dynamic> decoded = jsonDecode(savedData);
      allRecords = decoded.map((item) {
        final Map<String, dynamic> record = Map<String, dynamic>.from(item);
        record['date'] = DateTime.parse(record['date']);
        return record;
      }).toList();
    }

    if (allRecords.isEmpty) {
      DateTime today = DateTime.now();
      
      allRecords = [
        // Today
        {'title': 'HackWKND RedBull', 'amount': 6.50, 'date': today, 'category': 'Food'},
        // Yesterday
        {'title': 'Grab to UTM', 'amount': 15.00, 'date': today.subtract(const Duration(days: 1)), 'category': 'Transport'},
        // 2 Days Ago
        {'title': 'Figma Pro Plan', 'amount': 55.00, 'date': today.subtract(const Duration(days: 2)), 'category': 'Shopping'},
        // 5 Days Ago
        {'title': 'Pharmacy', 'amount': 24.00, 'date': today.subtract(const Duration(days: 5)), 'category': 'Health'},
        // Last Month
        {'title': 'Bowling Club Fees', 'amount': 30.00, 'date': DateTime(today.year, today.month - 1, 15), 'category': 'Others'},
      ];
      
      // Save these immediately so they act like real data
      await _saveToDisk();
    }
  }

  static Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(allRecords.map((r) {
      final map = Map<String, dynamic>.from(r);
      map['date'] = (map['date'] as DateTime).toIso8601String();
      return map;
    }).toList());
    await prefs.setString('spending_records', encodedData);
  }

  static Future<void> addRecord(Map<String, dynamic> record) async {
    allRecords.insert(0, record);
    await _saveToDisk();
  }

  static Future<void> deleteRecord(int index) async {
    allRecords.removeAt(index);
    await _saveToDisk();
  }

  static Future<void> updateRecord(int index, Map<String, dynamic> record) async {
    allRecords[index] = record;
    await _saveToDisk();
  }
}