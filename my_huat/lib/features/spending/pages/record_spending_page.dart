// lib/features/spending/pages/record_spending_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'spending_history_page.dart'; 
import 'package:my_huat/shared/widgets/arc_header.dart';

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
  final Color navyBlue = const Color(0xFF0D3A6D);

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

  Future<void> _presentDatePicker() async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            // 🌟 核心设置：将头部背景和选中的圆形设置为深蓝色
            primary: const Color(0xFF0D3A6D), 
            // 🌟 核心设置：将头部文字和选中日期的文字设置为白色
            onPrimary: Colors.white,           
            // 设置未选中日期文字的颜色（可选，建议也用深蓝色保持统一）
            onSurface: const Color(0xFF0D3A6D), 
          ),
          // 这里的设置确保“确定”和“取消”按钮也使用深蓝色
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0D3A6D), 
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) setState(() => _selectedDate = pickedDate);
}
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _receiptImage = File(pickedFile.path));
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('From Gallery'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.existingRecord != null;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Standard ArcHeader
          ArcHeader(title: "MHuat"),

          // 2. Return Arrow and Title Section (Aligned Top-Left)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Text(
                  isEdit ? "Edit Record" : "Record Spending",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyBlue),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 3. Circular Snap Photo Area with White Border
                  Center(
                    child: GestureDetector(
                      onTap: _showOptions,
                      child: Container(
                        padding: const EdgeInsets.all(6), // The white border
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey[100],
                          backgroundImage: _receiptImage != null ? FileImage(_receiptImage!) : null,
                          child: _receiptImage == null 
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 30, color: navyBlue),
                                  const SizedBox(height: 4),
                                  const Text("Snap", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              )
                            : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. BNPL Style Card for Main Inputs
                  Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildStyledTextField(
                            controller: _amountController,
                            label: "Amount (RM)",
                            icon: Icons.payments_outlined,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownField(),
                          const SizedBox(height: 16),
                          _buildDateField(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. Comments Section (Styled like BNPL Input)
                  _buildStyledTextField(
                    controller: _commentController,
                    label: "Comments (Optional)",
                    icon: Icons.notes,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 30),

                  // 6. Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navyBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                      ),
                      child: Text(
                        isEdit ? 'UPDATE CHANGES' : 'CONFIRM SPENDING',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
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

  // --- Helper Widgets ---

  Widget _buildStyledTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: navyBlue),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: navyBlue, width: 2)),
      ),
    );
  }

  Widget _buildDropdownField() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedCategory,
        isExpanded: true,
        icon: Icon(Icons.category_outlined, color: navyBlue),
        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (val) => setState(() => _selectedCategory = val!),
      ),
    ),
  );

  Widget _buildDateField() => InkWell(
    onTap: _presentDatePicker,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: navyBlue, size: 20),
          const SizedBox(width: 12),
          Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}