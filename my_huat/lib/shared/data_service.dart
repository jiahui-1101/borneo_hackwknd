import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  static List<Map<String, dynamic>> allRecords = [];

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('spending_records');
    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      allRecords = decoded.map((item) {
        final Map<String, dynamic> record = Map<String, dynamic>.from(item);
        record['date'] = DateTime.parse(record['date']);
        return record;
      }).toList();
    }
  }

  // 🌟 保存逻辑封装
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

  // 🌟 核心：删除记录
  static Future<void> deleteRecord(int index) async {
    allRecords.removeAt(index);
    await _saveToDisk();
  }

  // 🌟 核心：更新记录
  static Future<void> updateRecord(int index, Map<String, dynamic> record) async {
    allRecords[index] = record;
    await _saveToDisk();
  }
}