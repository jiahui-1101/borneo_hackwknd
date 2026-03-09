import 'package:flutter/material.dart';
import 'package:my_huat/shared/widgets/arc_header.dart'; // 确保路径正确

class MmfPage extends StatelessWidget {
  const MmfPage({super.key});

  // 统一定义的主题色
  final Color navyBlue = const Color(0xFF0D3A6D);
  final Color lightBlue = const Color(0xFF1080E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 统一白色背景
      body: Column(
        children: [
          // 顶部统一 Header
          const ArcHeader(title: "MHuat"),

          // 返回按钮与标题 (对齐 BnplCalculatorPage 的设计)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "MHuat+ (MMF)",
                  style: TextStyle(
                    fontSize: 24, // 统一字号
                    fontWeight: FontWeight.bold,
                    color: navyBlue, // 深蓝标题
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: Colors.black87),
              ],
            ),
          ),

          // 核心内容区
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0), // 统一外边距
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. 余额与收益卡片 (使用统一的 Card 样式)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Balance",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "RM3,400.00", // <-- 这里更新了余额
                              style: TextStyle(
                                color: navyBlue, // 使用深蓝色突出金额
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Maximum limit RM20,000.00",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(color: Colors.grey.shade200),
                            ),
                            
                            // 总收益 & 每日收益率
                            Row(
                              children: [
                                // 左侧：总收益
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Return", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "+RM 49.34",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(height: 40, width: 1, color: Colors.grey.shade200), // 分割线
                                // 右侧：每日净收益率
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Daily Return Rate", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                            const SizedBox(width: 4),
                                            Icon(Icons.info_outline, size: 14, color: Colors.grey.shade400),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "2.85% p.a.",
                                          style: TextStyle(
                                            color: navyBlue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 基金信息提示文字
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "MHuat+ underlying fund is Principal e-Cash, a Shariah-compliant money market fund.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. 广告推销卡片 (保持深蓝色块，但应用统一的 Card 参数)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: navyBlue,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Earn stable daily returns",
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Low risk",
                                    style: TextStyle(color: navyBlue, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "2.85%",
                              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "average return rate p.a.",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Invested safely in short-term bank deposits.",
                                    style: TextStyle(color: Colors.white54, fontSize: 11),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  child: const Text("Details"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. 交易记录卡片
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                    fontSize: 18, // 对齐子标题字号
                                    fontWeight: FontWeight.bold,
                                    color: navyBlue,
                                  ),
                                ),
                                Text(
                                  "View All",
                                  style: TextStyle(color: lightBlue, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTransactionItem("Daily Return", "+RM 0.12", "9 Mar, 00:41", true),
                            Divider(height: 24, color: Colors.grey.shade200),
                            _buildTransactionItem("Cash In", "+RM 100.00", "5 Mar, 14:20", true),
                            // <-- 这里的 Payment 记录被移除了
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 底部浮动按钮区
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60, // 统一按钮高度
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: lightBlue, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 统一圆角
                        ),
                        child: Text("Cash Out", style: TextStyle(color: lightBlue, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                        child: const Text("Cash In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  // 交易记录 Widget
  Widget _buildTransactionItem(String title, String amount, String date, bool isPositive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
            const SizedBox(height: 4),
            Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green : Colors.black87, // 正收益用绿色更符合财务直觉
          ),
        ),
      ],
    );
  }
}