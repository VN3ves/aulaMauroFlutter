import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'database_helper.dart';

void main() async {
  // Garante que o binding do Flutter seja inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o banco de dados antes de rodar o app
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}