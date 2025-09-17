import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const RaioApp());
}

class RaioApp extends StatelessWidget {
  const RaioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cálculo de Área',
      home: TelaRaio(),
    );
  }
}

// --- TELA 1: Inserir o Raio ---
class TelaRaio extends StatefulWidget {
  const TelaRaio({super.key});

  @override
  State<TelaRaio> createState() => _TelaRaioState();
}

class _TelaRaioState extends State<TelaRaio> {
  final TextEditingController _raioController = TextEditingController();

  void _calcularEExibirArea() {
    // Converte o texto para double, tratando possíveis erros de digitação.
    final double? raio = double.tryParse(_raioController.text);

    if (raio != null && raio > 0) {
      final double area = pi * raio * raio;
      // Navega para a segunda tela, passando o valor da área via construtor.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaArea(area: area)),
      );
    } else {
      // Mostra uma mensagem de erro se o valor for inválido.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um raio válido!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Área do Círculo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _raioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Digite o raio do círculo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularEExibirArea,
              child: const Text('Calcular Área'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TELA 2: Exibir a Área ---
class TelaArea extends StatelessWidget {
  final double area;

  // Construtor que exige o recebimento do valor da área.
  const TelaArea({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Text(
          // Mostra a área formatada com 2 casas decimais.
          'A área do círculo é: ${area.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}