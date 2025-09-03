import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp é um StatelessWidget que define a estrutura base do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorConsoleApp(),
    );
  }
}

// CalculatorConsoleApp é um StatefulWidget para gerenciar o estado da calculadora
class CalculatorConsoleApp extends StatefulWidget {
  const CalculatorConsoleApp({super.key});

  @override
  State<CalculatorConsoleApp> createState() => _CalculatorConsoleAppState();
}

// O estado da calculadora
class _CalculatorConsoleAppState extends State<CalculatorConsoleApp> {
  String _currentOperator1 = '';
  String _currentOperator2 = '';
  String _currentResult = '0';
  bool _isSumPressed = false;
  String _currentOperation = '';

  // Função que lida com o pressionar de cada botão
  void _onButtonPressed(String buttonText) {
    // Se o botão for um número
    if (RegExp(r'^[0-9]$').hasMatch(buttonText)) {
      if (_isSumPressed) {
        // Se a soma foi pressionada, comece a digitar o segundo operador
        _currentOperator2 += buttonText;
      } else {
        // Senão, comece a digitar o primeiro operador
        _currentOperator1 += buttonText;
      }
    }
    // Se o botão for a soma
    else if (buttonText == '+') {
      _isSumPressed = true;
      _currentOperation = '+';
      _currentResult = _currentOperator1;
    }
    // Se o botão for o sinal de igual
    else if (buttonText == '=') {
      double? num1 = double.tryParse(_currentOperator1);
      double? num2 = double.tryParse(_currentOperator2);

      if (num1 != null && num2 != null) {
        double calculatedResult = 0.0;
        if (_currentOperation == '+') {
          calculatedResult = num1 + num2;
        }

        _currentResult = calculatedResult.toString();
        // Resetar para a próxima operação
        _currentOperator1 = calculatedResult.toString();
        _currentOperator2 = '';
        _isSumPressed = false;
        _currentOperation = '';
      }
    }

    // Imprimir o estado atual no console, como solicitado
    setState(() {
      print('Operador 1: $_currentOperator1');
      print('Operador 2: $_currentOperator2');
      print('Soma apertado: $_isSumPressed');
      print('Resultado: $_currentResult');
    });
  }

  // Helper para construir uma linha de botões
  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((buttonText) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () => _onButtonPressed(buttonText),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          // Botões da calculadora
          Expanded(
            flex: 5,
            child: Column(
              children: <Widget>[
                _buildButtonRow(['7', '8', '9']),
                _buildButtonRow(['4', '5', '6']),
                _buildButtonRow(['1', '2', '3']),
                _buildButtonRow(['0', '+', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
