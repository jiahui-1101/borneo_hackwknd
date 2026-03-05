import 'package:flutter/material.dart';
import '../homepage/home_page.dart'; // 🌟 导入主页

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌟 独立蓝色弧形 (Join Us)
            ClipPath(
              clipper: _OnboardingArcClipper(),
              child: Container(
                width: double.infinity,
                height: topPadding + 110,
                color: const Color(0xFF0D3A6D),
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: topPadding),
                child: const Text(
                  'Join Us',
                  style: TextStyle(
                    fontFamily: 'CaveatFont', //
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
                  Image.asset('assets/entrypagecat.png', height: 90),
                  const Text(
                    'MHuat',
                    style: TextStyle(fontFamily: 'CaveatFont', fontSize: 30, color: Color(0xFF0D3A6D)),
                  ),
                  const SizedBox(height: 25),

                  // 🌟 按照你的要求精准修改的 Label
                  _buildTextField(label: 'user name', icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'please enter password', icon: Icons.lock_outline, isObscure: true),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'please enter password again', icon: Icons.lock_clock_outlined, isObscure: true),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'IC Number', icon: Icons.badge_outlined),
                  
                  const SizedBox(height: 35),

                  // 🌟 注册按钮：点击跳转
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3A6D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      child: const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),

                  // 返回登录
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Already have an account? Login", style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 20),
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

// 同样的独立 Clipper
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