import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'router.dart';


void main() async{
  await dotenv.load(fileName: '.env');

  await initializeDateFormatting("pt_BR", null);
  Intl.defaultLocale = "pt_BR";

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
