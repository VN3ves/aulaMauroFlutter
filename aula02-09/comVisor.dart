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
      home: const CalculatorApp(),
    );
  }
}

// CalculatorApp é um StatefulWidget para gerenciar o estado da calculadora
class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

// O estado da calculadora
class _CalculatorAppState extends State<CalculatorApp> {
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
        setState(() {
          _currentOperator2 += buttonText;
        });
      } else {
        // Senão, comece a digitar o primeiro operador
        setState(() {
          _currentOperator1 += buttonText;
        });
      }
    }
    // Se o botão for a soma
    else if (buttonText == '+') {
      setState(() {
        _isSumPressed = true;
        _currentOperation = '+';
        _currentResult = _currentOperator1;
      });
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

        setState(() {
          _currentResult = calculatedResult.toString();
          // Resetar para a próxima operação
          _currentOperator1 = calculatedResult.toString();
          _currentOperator2 = '';
          _isSumPressed = false;
          _currentOperation = '';
        });
      }
    }

    // Lógica para o botão de limpar (C)
    else if (buttonText == 'C') {
      setState(() {
        _currentOperator1 = '';
        _currentOperator2 = '';
        _currentResult = '0';
        _isSumPressed = false;
        _currentOperation = '';
      });
    }

    // Imprimir o estado atual no console, como solicitado
    print('Operador 1: $_currentOperator1');
    print('Operador 2: $_currentOperator2');
    print('Soma apertado: $_isSumPressed');
    print('Resultado: $_currentResult');
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
          // Display do resultado
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              alignment: Alignment.bottomRight,
              child: Text(
                _isSumPressed ? _currentOperator2.isEmpty ? '0' : _currentOperator2 : _currentOperator1.isEmpty ? '0' : _currentOperator1,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1.0),
          // Botões da calculadora
          Expanded(
            flex: 5,
            child: Column(
              children: <Widget>[
                _buildButtonRow(['7', '8', '9']),
                _buildButtonRow(['4', '5', '6']),
                _buildButtonRow(['1', '2', '3']),
                _buildButtonRow(['C', '0', '+', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
