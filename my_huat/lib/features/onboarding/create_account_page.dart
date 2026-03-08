import 'package:flutter/material.dart';
// 🌟 导入包含 Pin 码、国籍、通知设置的全新文件
import 'SetupPinPage.dart';

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
            // 独立蓝色弧形 (Join Us)
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
                    fontFamily: 'CaveatFont', 
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

                  _buildTextField(label: 'user name', icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  
                  _buildTextField(label: 'email address', icon: Icons.email_outlined),
                  const SizedBox(height: 16),
                  
                  // 🌟 Phone Code Dropdown
                  _buildPhoneCodeDropdown(),
                  const SizedBox(height: 16),
                  
                  _buildTextField(label: 'phone number', icon: Icons.phone_android_outlined),
                  const SizedBox(height: 16),

                  _buildTextField(label: 'please enter password', icon: Icons.lock_outline, isObscure: true),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'please enter password again', icon: Icons.lock_clock_outlined, isObscure: true),
                  
                  const SizedBox(height: 35),

                  // 🌟 核心修改：点击后去往 Setup Pin 页面
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3A6D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        // 🌟 这里改成推送到下一页 (Progressive Onboarding)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  SetupPinPage()),
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

  Widget _buildPhoneCodeDropdown() {
    final List<Map<String, String>> aseanCodes = [
      {'code': '+60', 'country': 'Malaysia (+60)'},
      {'code': '+65', 'country': 'Singapore (+65)'},
      {'code': '+62', 'country': 'Indonesia (+62)'},
      {'code': '+66', 'country': 'Thailand (+66)'},
      {'code': '+63', 'country': 'Philippines (+63)'},
      {'code': '+84', 'country': 'Vietnam (+84)'},
      {'code': '+95', 'country': 'Myanmar (+95)'},
      {'code': '+855', 'country': 'Cambodia (+855)'},
      {'code': '+856', 'country': 'Laos (+856)'},
      {'code': '+673', 'country': 'Brunei (+673)'},
    ];

    String selectedCode = '+60';

    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButtonFormField<String>(
          value: selectedCode,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0D3A6D)),
          decoration: InputDecoration(
            labelText: 'phone code',
            prefixIcon: const Icon(Icons.public, color: Color(0xFF0D3A6D)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
          items: aseanCodes.map((item) {
            return DropdownMenuItem<String>(
              value: item['code'],
              child: Text(item['country']!, style: const TextStyle(fontSize: 15)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedCode = value);
            }
          },
        );
      }
    );
  }
}

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