import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart'; 
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'package:my_huat/shared/data_service.dart';

class RecordSpendingPage extends StatefulWidget {
  final Map<String, dynamic>? existingRecord;
  final int? index;
  const RecordSpendingPage({super.key, this.existingRecord, this.index});

  @override
  State<RecordSpendingPage> createState() => _RecordSpendingPageState();
}

class _RecordSpendingPageState extends State<RecordSpendingPage> {
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  
  late final GenerativeModel _aiModel;
  bool _isAnalyzing = false; 

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();
  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Health', 'Bills', 'Others'];
  final Color navyBlue = const Color(0xFF0D3A6D);

  @override
  void initState() {
    super.initState();
    _initModel(); 
    // 🌟 核心修复：如果是编辑模式，自动填充旧数据
    if (widget.existingRecord != null) {
      _amountController.text = widget.existingRecord!['amount']?.toString() ?? '';
      _commentController.text = widget.existingRecord!['title'] ?? '';
      _selectedCategory = widget.existingRecord!['category'] ?? 'Food';
      _selectedDate = widget.existingRecord!['date'] ?? DateTime.now();
    }
  }

  // 🌟 核心修复：整合后的确认逻辑，支持新增和更新
  void _handleConfirm() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter amount!"))
      );
      return;
    }

    final Map<String, dynamic> recordData = {
      'title': _commentController.text.isEmpty ? 'New Record' : _commentController.text,
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'category': _selectedCategory,
      'date': _selectedDate,
    };

    // 判断是编辑已有记录还是新增记录
    if (widget.index != null) {
      await DataService.updateRecord(widget.index!, recordData);
    } else {
      await DataService.addRecord(recordData);
    }

    if (mounted) Navigator.pop(context); 
  }

  void _initModel() {
    _aiModel = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: GenerationConfig(temperature: 0.1),
    );
  }

  Future<void> _analyzeReceipt(File imageFile) async {
    setState(() => _isAnalyzing = true);
    try {
      final bytes = await imageFile.readAsBytes();
      final content = [
        Content.multi([
          TextPart("""Analyze this receipt. Return ONLY JSON:
          {"amount": 0.0, "category": "Food", "date": "YYYY-MM-DD", "comment": ""}
          Categories: ${_categories.join(', ')}."""),
          InlineDataPart('image/jpeg', bytes), 
        ])
      ];

      final response = await _aiModel.generateContent(content);
      if (response.text != null) {
        final cleanJson = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
        final Map<String, dynamic> data = jsonDecode(cleanJson);
        setState(() {
          if (data['amount'] != null) _amountController.text = data['amount'].toString();
          if (data['category'] != null && _categories.contains(data['category'])) _selectedCategory = data['category'];
          if (data['date'] != null) _selectedDate = DateTime.tryParse(data['date']) ?? DateTime.now();
          if (data['comment'] != null) _commentController.text = data['comment'];
        });
      }
    } catch (e) {
      debugPrint("AI Error: $e");
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, maxWidth: 1800, imageQuality: 95);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() => _receiptImage = file);
        await _analyzeReceipt(file); 
      }
    } catch (e) {
      debugPrint("Picker Error: $e");
    }
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.index != null; // 🌟 这里的逻辑更准确
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ArcHeader(title: "MHuat"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                Text(isEdit ? "Edit Record" : "Record Spending", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navyBlue)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildPhotoSection(),
                  const SizedBox(height: 24),
                  _buildInputFields(),
                  const SizedBox(height: 30),
                  _buildConfirmButton(isEdit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: GestureDetector(
        onTap: _showOptions,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey[100],
            backgroundImage: _receiptImage != null ? FileImage(_receiptImage!) : null,
            child: _isAnalyzing 
                ? CircularProgressIndicator(color: navyBlue)
                : (_receiptImage == null 
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 30, color: navyBlue),
                          const SizedBox(height: 4),
                          const Text("Snap Receipt", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ) 
                    : null),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildTextField(_amountController, "Amount (RM)", Icons.payments_outlined, TextInputType.number),
        const SizedBox(height: 16),
        _buildDropdown(),
        const SizedBox(height: 16),
        _buildDatePicker(),
        const SizedBox(height: 16),
        _buildTextField(_commentController, "Note", Icons.notes, TextInputType.text, maxLines: 2),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, TextInputType type, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: navyBlue), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2024), lastDate: DateTime(2030));
        if (d != null) setState(() => _selectedDate = d);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: navyBlue, size: 20),
            const SizedBox(width: 12),
            Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(bool isEdit) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _handleConfirm, 
        style: ElevatedButton.styleFrom(backgroundColor: navyBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text(isEdit ? "UPDATE" : "CONFIRM", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void dispose() { _amountController.dispose(); _commentController.dispose(); super.dispose(); }
}