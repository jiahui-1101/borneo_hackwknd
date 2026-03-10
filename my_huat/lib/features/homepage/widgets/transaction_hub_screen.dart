import 'package:flutter/material.dart';
import 'package:my_huat/shared/models/fund_type.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'package:my_huat/features/homepage/widgets/cash_in_screen.dart'; // 确保路径正确

class TransactionHubScreen extends StatefulWidget {
  final FundType fundType;
  final int initialIndex; // 🌟 新增参数：用来判断默认打开 Cash In 还是 Cash Out

  const TransactionHubScreen({
    super.key, 
    required this.fundType,
    this.initialIndex = 0, // 默认 0 (Cash In)
  });

  @override
  State<TransactionHubScreen> createState() => _TransactionHubScreenState();
}

class _TransactionHubScreenState extends State<TransactionHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 🌟 传入 widget.initialIndex 让它决定初始 Tab
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ArcHeader(title: "MHuat"),
          
          // Header with Back Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0D3A6D)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Manage Funds",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D3A6D),
                  ),
                ),
              ],
            ),
          ),

          // Custom TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0EDFE),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF1080E7),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF0D3A6D),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(child: Text("CASH IN", style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(child: Text("CASH OUT", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMethodList(isCashIn: true),
                _buildMethodList(isCashIn: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodList({required bool isCashIn}) {
    final List<Map<String, dynamic>> methods = isCashIn
        ? [
            {'name': 'CIMB Clicks', 'icon': Icons.account_balance, 'desc': 'Direct bank login'},
            {'name': 'FPX Online Banking', 'icon': Icons.payment, 'desc': 'Support all major banks'},
            {'name': 'Credit/Debit Card', 'icon': Icons.credit_card, 'desc': 'Visa & Mastercard'},
          ]
        : [
            {'name': 'Touch \'n Go eWallet', 'icon': Icons.account_balance_wallet, 'desc': 'Instant transfer'},
            {'name': 'Bank Transfer (IBG)', 'icon': Icons.send_to_mobile, 'desc': '1-2 business days'},
            {'name': 'GrabPay', 'icon': Icons.account_balance_wallet_outlined, 'desc': 'Fast & Secure'},
          ];
          
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: methods.length,
      itemBuilder: (context, index) {
        final method = methods[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0EDFE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method['icon'], color: const Color(0xFF0462C2)),
            ),
            title: Text(
              method['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D)),
            ),
            subtitle: Text(method['desc'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF0462C2)),
            onTap: () {
              if (isCashIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CashInScreen(fundType: widget.fundType),
                  ),
                );
              } else {
                // TODO: 添加 Cash Out 的跳转逻辑
              }
            },
          ),
        );
      },
    );
  }
}