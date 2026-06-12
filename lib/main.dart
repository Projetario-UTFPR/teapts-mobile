import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front_pi/login.dart';
import 'router.dart';
import 'widgets/upload_file.dart';
import 'package:go_router/go_router.dart';


void main() async{
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
  return  MaterialApp.router(
    routerConfig: appRouter,
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
);
  }
}
