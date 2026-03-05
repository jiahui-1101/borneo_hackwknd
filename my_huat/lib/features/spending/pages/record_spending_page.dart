// lib/features/spending/pages/record_spending_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'spending_history_page.dart'; 

class RecordSpendingPage extends StatefulWidget {
  final Map<String, dynamic>? existingRecord;
  const RecordSpendingPage({super.key, this.existingRecord});

  @override
  State<RecordSpendingPage> createState() => _RecordSpendingPageState();
}

class _RecordSpendingPageState extends State<RecordSpendingPage> {
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  String _selectedCategory = 'Food'; 
  DateTime _selectedDate = DateTime.now();
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();
  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Health', 'Bills', 'Others'];

  @override
  void initState() {
    super.initState();
    if (widget.existingRecord != null) {
      _amountController.text = widget.existingRecord!['amount']?.toString() ?? '';
      _commentController.text = widget.existingRecord!['comment'] ?? '';
      _selectedCategory = widget.existingRecord!['category'] ?? 'Food';
      _selectedDate = widget.existingRecord!['date'] ?? DateTime.now();
    }
  }

  void _navigateToHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SpendingHistoryPage()));
  }

  Future<void> _presentDatePicker() async {
    final pickedDate = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2024), lastDate: DateTime.now());
    if (pickedDate != null) setState(() => _selectedDate = pickedDate);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _receiptImage = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.existingRecord != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Record' : 'Record Spending', style: const TextStyle(fontFamily: 'CaveatFont', fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D3A6D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.history, size: 28), tooltip: 'View History', onPressed: _navigateToHistory), // 🌟 已修复括号错误
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("How much did you spend?"),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D)),
              decoration: InputDecoration(prefixText: 'RM ', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 25),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Category"), Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _selectedCategory, isExpanded: true, items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (val) => setState(() => _selectedCategory = val!))))])),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Date"), InkWell(onTap: _presentDatePicker, child: Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)), child: Row(children: [const Icon(Icons.calendar_month, size: 18, color: Color(0xFF0D3A6D)), const SizedBox(width: 8), Text(DateFormat('dd/MM/yyyy').format(_selectedDate))])))]))
            ]),
            const SizedBox(height: 25),
            _buildLabel("Receipt Image"),
            GestureDetector(onTap: _showOptions, child: Container(width: double.infinity, height: 160, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey[300]!)), child: _receiptImage != null ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(_receiptImage!, fit: BoxFit.cover)) : const Center(child: Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey)))),
            const SizedBox(height: 25),
            _buildLabel("Comments"),
            TextField(controller: _commentController, maxLines: 2, decoration: InputDecoration(hintText: 'Optional notes...', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3A6D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), onPressed: () => Navigator.pop(context), child: Text(isEdit ? 'Update Changes' : 'Confirm Spending', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))))
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));

  void _showOptions() {
    showModalBottomSheet(context: context, builder: (context) => SafeArea(child: Wrap(children: [ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take Photo'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }), ListTile(leading: const Icon(Icons.photo_library), title: const Text('From Gallery'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); })])));
  }
}