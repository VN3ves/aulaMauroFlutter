import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CirculoAbasApp());
}

class CirculoAbasApp extends StatelessWidget {
  const CirculoAbasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cálculos do Círculo',
      home: TelaPrincipalAbas(),
    );
  }
}

class TelaPrincipalAbas extends StatefulWidget {
  const TelaPrincipalAbas({super.key});

  @override
  State<TelaPrincipalAbas> createState() => _TelaPrincipalAbasState();
}

class _TelaPrincipalAbasState extends State<TelaPrincipalAbas> {
  final TextEditingController _raioController = TextEditingController();
  double _diametro = 0.0;
  double _circunferencia = 0.0;
  double _area = 0.0;

  void _calcular() {
    final double? raio = double.tryParse(_raioController.text);
    if (raio != null) {
      setState(() {
        _diametro = 2 * raio;
        _circunferencia = 2 * pi * raio;
        _area = pi * raio * raio;
      });
    } else {
      // Se o campo estiver vazio ou inválido, zera os valores.
      setState(() {
        _diametro = 0.0;
        _circunferencia = 0.0;
        _area = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // O DefaultTabController coordena a TabBar e a TabBarView.
    return DefaultTabController(
      length: 4, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cálculos do Círculo'),
          // A TabBar fica na parte de baixo do AppBar.
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Raio'),
              Tab(text: 'Diâmetro'),
              Tab(text: 'Circunferência'),
              Tab(text: 'Área'),
            ],
          ),
        ),
        // A TabBarView contém o conteúdo de cada aba, na mesma ordem.
        body: TabBarView(
          children: [
            // Conteúdo da Aba 1: Raio
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _raioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Digite o Raio'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calcular,
                    child: const Text('Calcular'),
                  ),
                ],
              ),
            ),
            // Conteúdo da Aba 2: Diâmetro
            Center(child: Text('Diâmetro: ${_diametro.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24))),
            // Conteúdo da Aba 3: Circunferência
            Center(child: Text('Circunferência: ${_circunferencia.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24))),
            // Conteúdo da Aba 4: Área
            Center(child: Text('Área: ${_area.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}