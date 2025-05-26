import 'package:flutter/material.dart';
import 'package:english_word_app/pages/login_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QWorDaZy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'carter',
      ),
      home: const LoginPage(),
    );
  }
}




