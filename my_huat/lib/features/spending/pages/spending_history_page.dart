import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'record_spending_page.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'package:my_huat/shared/data_service.dart';

class SpendingHistoryPage extends StatefulWidget {
  const SpendingHistoryPage({super.key});

  @override
  State<SpendingHistoryPage> createState() => _SpendingHistoryPageState();
}

class _SpendingHistoryPageState extends State<SpendingHistoryPage> {
  final Color navyBlue = const Color(0xFF0D3A6D);
  List<Map<String, dynamic>> _displayData = [];
  String _filterMode = 'Day'; 
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  // 🌟 核心逻辑：从仓库拿数据并根据滤镜显示
  void _applyFilter() {
    setState(() {
      _displayData = DataService.allRecords.where((item) {
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

  // 🌟 核心修复：补全缺失的日期选择函数
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: _selectedDate, 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now(),
      initialDatePickerMode: _filterMode == 'Year' ? DatePickerMode.year : DatePickerMode.day,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: navyBlue, 
            onPrimary: Colors.white, 
            onSurface: navyBlue
          )
        ),
        child: child!,
      ),
    );
    if (picked != null) { 
      setState(() { 
        _selectedDate = picked; 
        _applyFilter(); 
      }); 
    }
  }

  Future<void> _addNewRecord() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecordSpendingPage()),
    );
    _applyFilter(); 
  }

  double get _totalSpent => _displayData.fold(0.0, (sum, item) => sum + (item['amount'] as double));

  BoxDecoration _softModuleDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black.withOpacity(0.04), width: 1), 
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 8), blurRadius: 15)],
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateLabel = DateFormat('dd MMM yyyy').format(_selectedDate);
    if (_filterMode == 'Month') dateLabel = DateFormat('MMMM yyyy').format(_selectedDate);
    if (_filterMode == 'Year') dateLabel = DateFormat('yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRecord,
        backgroundColor: navyBlue,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
      body: Column(
        children: [
          ArcHeader(title: "MHuat"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                const Spacer(),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(20), selectedColor: Colors.white, fillColor: navyBlue,
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
          _buildDateSelector(dateLabel),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), 
              child: Column(
                children: [
                  Container(
                    width: double.infinity, decoration: _softModuleDecoration(),
                    child: _displayData.isEmpty 
                      ? const Padding(padding: EdgeInsets.all(50), child: Center(child: Text("No records found.")))
                      : Column(
                          children: _displayData.asMap().entries.map((entry) {
                            return Column(
                              children: [
                                _buildTransactionTile(entry.value),
                                if (entry.key != _displayData.length - 1)
                                  Divider(color: Colors.grey.withOpacity(0.08), height: 1, indent: 20, endIndent: 20),
                              ],
                            );
                          }).toList(),
                        ),
                  ),
                  const SizedBox(height: 24),
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
      onTap: _pickDate, // 🌟 修复后的调用
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), padding: const EdgeInsets.all(16),
        decoration: _softModuleDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Viewing:", style: TextStyle(color: Colors.grey[600])),
            Row(children: [Text(label, style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold)), const SizedBox(width: 8), Icon(Icons.edit_calendar, color: navyBlue, size: 20)]),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(24), decoration: _softModuleDecoration(color: navyBlue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("TOTAL", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          Text("RM ${_totalSpent.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  // 🌟 增强版 Tile：带左滑删除和点击编辑
  Widget _buildTransactionTile(Map<String, dynamic> item) {
    final int masterIndex = DataService.allRecords.indexOf(item);

    return Dismissible(
      key: Key(item.toString() + masterIndex.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await DataService.deleteRecord(masterIndex);
        _applyFilter(); 
      },
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordSpendingPage(
                existingRecord: item,
                index: masterIndex,
              ),
            ),
          );
          _applyFilter(); 
        },
        leading: CircleAvatar(
          radius: 18, 
          backgroundColor: navyBlue.withOpacity(0.04), 
          child: Icon(_getCategoryIcon(item['category']), color: navyBlue, size: 18)
        ),
        title: Text(item['title'] ?? 'Record', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(DateFormat('dd MMM yyyy').format(item['date'] ?? DateTime.now())),
        trailing: Text("RM ${(item['amount'] as double).toStringAsFixed(2)}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
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