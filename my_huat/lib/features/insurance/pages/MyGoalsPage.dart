import 'package:flutter/material.dart';

class MyGoalsPage extends StatelessWidget {
  const MyGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag,
              size: 80,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'My Goals Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '(Temporary Page)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}