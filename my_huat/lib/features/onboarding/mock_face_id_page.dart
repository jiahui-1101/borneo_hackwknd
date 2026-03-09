import 'package:flutter/material.dart';
import '../homepage/home_page.dart';

class MockFaceIdPage extends StatefulWidget {
  const MockFaceIdPage({super.key});

  @override
  State<MockFaceIdPage> createState() => _MockFaceIdPageState();
}

class _MockFaceIdPageState extends State<MockFaceIdPage> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // 假装扫描 2 秒
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isAuthenticated = true; // 变绿勾勾
        });
        
        // 成功后停留 0.8 秒再进主页
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取顶部状态栏的高度，避免被刘海屏挡住
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // 🌟 半透明的黑色背景，能透出底下的 Login 页面
      body: Align(
        alignment: Alignment.topCenter, // 🌟 核心：放在正上方（楼上）
        child: Container(
          margin: EdgeInsets.only(top: topPadding + 15), // 距离顶部留一点空隙
          width: 150,
          height: 150, // 🌟 像图片里一样的正方形
          decoration: BoxDecoration(
            color: Colors.black, // 🌟 纯黑的底色
            borderRadius: BorderRadius.circular(40), // 🌟 Apple 风格的超大圆角
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // 🌟 模仿图片里的绿色发光扫描圈
                  if (!_isAuthenticated)
                    const SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        strokeWidth: 3,
                      ),
                    ),
                  
                  // 🌟 中间的图标：扫描时是人脸，成功时是勾勾
                  Icon(
                    _isAuthenticated ? Icons.check_rounded : Icons.face_unlock_outlined,
                    size: 50,
                    color: Colors.greenAccent, // 配合图片用荧光绿
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}