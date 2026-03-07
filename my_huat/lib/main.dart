import 'package:flutter/material.dart';
import 'features/homepage/home_page.dart';
import 'package:my_huat/shared/data_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/onboarding/entry_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DataService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MHuat',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primaryColor: const Color(0xFF0D3A6D), 
        useMaterial3: true,
      ),
      home: const EntryPage(),
    );
  }
}