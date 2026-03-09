import 'package:flutter/material.dart';
import '../homepage/home_page.dart';

// ==========================================
// 1. 设置 PIN 码页面 (Setup PIN Page)
// ==========================================
class SetupPinPage extends StatelessWidget {
  const SetupPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, 'Secure PIN'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Icon(Icons.dialpad, size: 70, color: Color(0xFF0D3A6D)),
                  const SizedBox(height: 16),
                  const Text("Secure Your Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 8),
                  Text("Create a 6-digit PIN for quick access", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 40),
                  
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D)),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3A6D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      // 🌟 这里修好了！点击 Next 现在会去往 EnableFaceIdPage 🌟
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EnableFaceIdPage())),
                      child: const Text('Next', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1.5 开启 Face ID 页面 (Enable Face ID Page)
// ==========================================
class EnableFaceIdPage extends StatelessWidget {
  const EnableFaceIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, 'Biometrics'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // 🌟 带浅蓝色背景的圆角图标，看起来很清爽
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.face_unlock_outlined, size: 70, color: Color(0xFF0D3A6D)),
                  ),
                  const SizedBox(height: 32),
                  const Text("Enable Face ID?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 12),
                  Text(
                    "Log in faster and more securely to Warung Wise using just your face.", 
                    textAlign: TextAlign.center, 
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5)
                  ),
                  const SizedBox(height: 60),
                  
                  // 🌟 Enable 按钮
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3A6D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        // 🌟 点击开启，前往下一步 (Country)
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CountrySetupPage()));
                      },
                      child: const Text('Enable Face ID', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // 🌟 Skip 按钮
                  TextButton(
                    onPressed: () {
                      // 🌟 点击跳过，也是前往下一步 (Country)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CountrySetupPage()));
                    },
                    child: const Text("Skip for now", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. 国家设置页面 (Country Setup Page)
// ==========================================
class CountrySetupPage extends StatefulWidget {
  const CountrySetupPage({super.key});

  @override
  State<CountrySetupPage> createState() => _CountrySetupPageState();
}

class _CountrySetupPageState extends State<CountrySetupPage> {
  String _selectedCountry = '🇲🇾 Malaysia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, 'Location'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text("Where are you?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 8),
                  Text("Select your country to localize your experience.", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 40),

                  const Text("Country", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedCountry,
                    items: ['🇲🇾 Malaysia', '🇸🇬 Singapore', '🇮🇩 Indonesia', '🇹🇭 Thailand', '🇵🇭 Philippines', '🇻🇳 Vietnam'],
                    onChanged: (val) => setState(() => _selectedCountry = val!),
                  ),

                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3A6D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrencySetupPage())),
                      child: const Text('Next', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. 货币设置页面 (Currency Setup Page)
// ==========================================
class CurrencySetupPage extends StatefulWidget {
  const CurrencySetupPage({super.key});

  @override
  State<CurrencySetupPage> createState() => _CurrencySetupPageState();
}

class _CurrencySetupPageState extends State<CurrencySetupPage> {
  String _selectedCurrency = 'RM (MYR)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, 'Currency'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text("Set your Currency", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 8),
                  Text("What currency you wish to use?", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 40),

                  const Text("Default Currency", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedCurrency,
                    items: ['RM (MYR)', '\$ (SGD)', 'Rp (IDR)', '฿ (THB)', '₱ (PHP)', '₫ (VND)'],
                    onChanged: (val) => setState(() => _selectedCurrency = val!),
                  ),

                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3A6D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())),
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. 开启通知页面 (Enable Notification Page)
// ==========================================
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, 'Alerts'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_active_outlined, size: 70, color: Colors.orange),
                  ),
                  const SizedBox(height: 32),
                  const Text("Turn on Notifications?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D))),
                  const SizedBox(height: 12),
                  Text(
                    "Get instant alerts for your daily expenses, AI bookkeeping summaries, and BNPL reminders.", 
                    textAlign: TextAlign.center, 
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5)
                  ),
                  const SizedBox(height: 60),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3A6D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () => _goToHome(context),
                      child: const Text('Allow Notifications', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  TextButton(
                    onPressed: () => _goToHome(context),
                    child: const Text("Skip for now", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }
}

// ==========================================
// 🌟 Shared Components
// ==========================================

Widget _buildHeader(BuildContext context, String title) {
  final topPadding = MediaQuery.of(context).padding.top;
  return ClipPath(
    clipper: _OnboardingArcClipper(),
    child: Container(
      width: double.infinity,
      height: topPadding + 110,
      color: const Color(0xFF0D3A6D),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: topPadding),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'CaveatFont', 
          fontSize: 38,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[50], 
      borderRadius: BorderRadius.circular(15), 
      border: Border.all(color: Colors.grey[200]!)
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0D3A6D)),
        items: items.map((String item) => DropdownMenuItem(
          value: item, 
          child: Text(item, style: const TextStyle(fontSize: 16, color: Color(0xFF0D3A6D)))
        )).toList(),
        onChanged: onChanged,
      ),
    ),
  );
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