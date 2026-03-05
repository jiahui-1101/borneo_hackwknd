import 'package:flutter/material.dart';
import 'login_page.dart'; 
import 'create_account_page.dart'; 

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3A6D), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            const Text(
              'MHuat',
              style: TextStyle(
                fontFamily: 'CaveatFont', 
                fontSize: 65,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 10),

            
            Image.asset('assets/entrypagecat.png', height: 180),

            const SizedBox(height: 15),

          
            const Text(
              'invest easily, grow your huat',
              style: TextStyle(
                fontFamily: 'CaveatFont',
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
                letterSpacing: 0.8,
              ),
            ),
            
            const SizedBox(height: 80),

            // 🌟 4. Login 按钮
            SizedBox(
              width: 250,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D3A6D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 10),

            // 🌟 5. Create Account 链接
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountPage())),
              child: const Text('Create Account', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}