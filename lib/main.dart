import 'package:flutter/material.dart';
import 'Theme/dark_theme.dart';
import 'Theme/lightTheme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MoneyraApp());
}

class MoneyraApp extends StatelessWidget {
  const MoneyraApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Moneyra',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}
