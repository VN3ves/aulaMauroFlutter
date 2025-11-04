// lib/main.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  // Garante que os bindings do Flutter sejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        // Use Material 3 para um visual mais limpo e moderno
        useMaterial3: true,
        // Crie um esquema de cores a partir de uma "semente" (seed)
        // Isso gera uma paleta de cores harmoniosa automaticamente
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        // Vamos dar uma aparência mais limpa para os Cards
        cardTheme: CardThemeData(
          elevation: 1, // Sombra sutil
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // E para o botão flutuante
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        // E para a AppBar
        appBarTheme: const AppBarTheme(
          elevation: 1,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent, // Remove o tom de "elevação" do M3
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}