import 'package:flutter/material.dart';
import 'create_account.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
  return  MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 15, 68, 111),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFCF2), 
    appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFCF2),
    elevation: 0,
    foregroundColor: Colors.black, 
  ),
  ),
  home: const SignUpPage(),
);
  }
}
