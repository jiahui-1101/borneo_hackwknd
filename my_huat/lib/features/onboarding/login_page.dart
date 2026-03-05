import 'package:flutter/material.dart';
import '../homepage/home_page.dart'; // 🌟 导入主页以实现跳转
import 'create_account_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌟 独立蓝色弧形 (只有文字)
            ClipPath(
              clipper: _OnboardingArcClipper(),
              child: Container(
                width: double.infinity,
                height: topPadding + 110,
                color: const Color(0xFF0D3A6D), // 招牌深蓝色
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: topPadding),
                child: const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontFamily: 'CaveatFont', // 🌟 你的品牌字体
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  // 🌟 Logo 组合：猫 + MHuat
                  Image.asset('assets/entrypagecat.png', height: 100),
                  const Text(
                    'MHuat',
                    style: TextStyle(
                      fontFamily: 'CaveatFont', 
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D3A6D),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 输入框
                  _buildTextField(label: 'Email Address', icon: Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Password', icon: Icons.lock_outline, isObscure: true),
                  
                  const SizedBox(height: 40),

                  // 🌟 登录按钮：点击后跳转到 HomePage
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3A6D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        // 🌟 跳转并清空页面栈
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),

                  // 跳转注册
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountPage()));
                    },
                    child: const Text("Don't have an account? Create one", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, bool isObscure = false}) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0D3A6D)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }
}

// 独立的弧形裁剪器
class _OnboardingArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(size.width * 3 / 4, size.height - 40, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}