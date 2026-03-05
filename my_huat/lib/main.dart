import 'package:flutter/material.dart';
// 1. 导入你的入口页面。注意：如果你还没改文件名，这里可能是 onboarding.dart
import 'features/onboarding/entry_page.dart'; 
import 'features/homepage/home_page.dart';

void main() {
  runApp(const MyApp());
} // 🌟 补上了你漏掉的这个括号

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MHuat',
      debugShowCheckedModeBanner: false, // 去掉右上角的 DEBUG 标志
      theme: ThemeData(
        // 使用你定义的品牌深蓝色作为主题色
        primaryColor: const Color(0xFF0D3A6D), 
        useMaterial3: true,
      ),
      // 2. 🌟 关键修改：让 App 启动后先进入 EntryPage
      home: const EntryPage(), 
    );
  }
}