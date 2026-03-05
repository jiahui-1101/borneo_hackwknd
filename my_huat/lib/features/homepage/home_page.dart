// lib/features/homepage/home_page.dart
import 'package:flutter/material.dart';

import '../../shared/widgets/arc_header.dart';

// Import pages
import '../spending/pages/savings_page.dart';
import '../investing/pages/invest_page.dart';
import '../insurance/pages/insurance_page.dart';
import '../setting/pages/settings_page.dart';

// Homepage content
import 'homepage_dashboard.dart';

// 🌟 1. 导入你的全局 AI 助手页面
import 'package:my_huat/features/ai_feature/ai_chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeDashboard(),
    SavingsPage(),
    InvestPage(),
    InsurancePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ArcHeader(title: 'MHuat'),

          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      
      // 🌟 2. 核心魔法：这就是你的全局 AI 悬浮按钮！
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 点击后弹出聊天界面
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AiChatPage()),
          );
        },
        backgroundColor: Colors.amber[700],
        elevation: 6, // 悬空阴影效果
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // 完美的圆形
        ),
        // 🌟 只能保留一个 child！这是深蓝色的机器人图标，和琥珀色背景绝配
        child: const Icon(Icons.smart_toy, color: Colors.white, size: 28),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6A5AE0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Invest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Insurance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}