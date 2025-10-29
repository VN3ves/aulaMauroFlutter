import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'history_screen.dart'; // Importa a nova tela

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = '0';
  double _memoryValue = 0.0;
  double? _firstOperand;
  String? _operation;
  bool _isEnteringSecondOperand = false;

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadStateFromDb();
  }

  // Carrega o estado salvo do BD ao iniciar
  Future<void> _loadStateFromDb() async {
    try {
      final state = await dbHelper.loadState();
      setState(() {
        _displayValue = state['displayValue'];
        _memoryValue = state['memoryValue'];
      });
    } catch (e) {
      // Lida com o caso de não haver estado salvo (primeira execução)
      _saveStateToDb(); 
    }
  }

  // Salva o estado atual no BD
  Future<void> _saveStateToDb() async {
    await dbHelper.saveState(_displayValue, _memoryValue);
  }

  // Salva o log da operação no BD
  Future<void> _saveOperationLog(String log) async {
    await dbHelper.saveOperation(log);
  }

  void _onButtonPressed(String text) {
    setState(() {
      switch (text) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '.':
          _handleNumber(text);
          break;

        case '+':
        case '-':
        case '*':
        case '/':
          _handleOperation(text);
          break;

        case '=':
          _handleEquals();
          break;

        case 'C':
          _handleClear();
          break;

        case 'MC':
          _memoryValue = 0.0;
          break;
        case 'MR':
          _displayValue = _memoryValue.toString();
          _isEnteringSecondOperand = true; // Próximo número substitui o display
          break;
        case 'M+':
          _memoryValue += double.parse(_displayValue);
          break;
        case 'M-':
          _memoryValue -= double.parse(_displayValue);
          break;
      }
    });
    // Salva o estado (display e memória) após qualquer operação
    _saveStateToDb();
  }

  void _handleNumber(String num) {
    if (_isEnteringSecondOperand) {
      _displayValue = num;
      _isEnteringSecondOperand = false;
    } else if (_displayValue == '0') {
      _displayValue = num == '.' ? '0.' : num;
    } else if (num == '.' && _displayValue.contains('.')) {
      return; // Evita múltiplos pontos decimais
    } else {
      _displayValue += num;
    }
  }

  void _handleOperation(String op) {
    _firstOperand = double.parse(_displayValue);
    _operation = op;
    _isEnteringSecondOperand = true;
  }

  void _handleEquals() {
    if (_firstOperand == null || _operation == null || _isEnteringSecondOperand) {
      return;
    }

    final double secondOperand = double.parse(_displayValue);
    double result = 0.0;

    switch (_operation) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '*':
        result = _firstOperand! * secondOperand;
        break;
      case '/':
        if (secondOperand == 0) {
          _displayValue = 'Erro';
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
    }

    String operationLog =
        "$_firstOperand $_operation $secondOperand = $result";
    
    // Salva a operação na tabela 'operacoes'
    _saveOperationLog(operationLog);

    _displayValue = result.toString();
    _firstOperand = null;
    _operation = null;
    _isEnteringSecondOperand = true; // Permite iniciar nova operação
  }

  void _handleClear() {
    _displayValue = '0';
    _firstOperand = null;
    _operation = null;
    _isEnteringSecondOperand = false;
  }
  
  // Refatoração final do layout no build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _memoryValue == 0.0 ? '' : 'M: $_memoryValue',
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  _displayValue,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Divider(),
          // Teclado
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // Layout com Colunas e Linhas (Versão Correta)
              child: Column(
                children: [
                  _buildButtonRowFlex(['MC', 'MR', 'M-', 'M+'], isMemory: true),
                  _buildButtonRowFlex(['C', '/', '*', '-'], isOperator: true),
                  Expanded(
                    flex: 2, // Linhas de números ocupam mais espaço
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3, // Bloco 7,8,9,4,5,6,1,2,3
                          child: Column(
                            children: [
                              _buildButtonRowFlex(['7', '8', '9']),
                              _buildButtonRowFlex(['4', '5', '6']),
                              _buildButtonRowFlex(['1', '2', '3']),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1, // Bloco +, =
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: _buildStyledButton('+', isOperator: true),
                                ),
                              ),
                              Expanded(
                                flex: 2, // '=' ocupa 2 espaços de altura
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: _buildStyledButton('=', isOperator: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2, // '0' ocupa 2 espaços
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _buildStyledButton('0'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _buildStyledButton('.'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Novo helper para linhas com flex
  Widget _buildButtonRowFlex(List<String> buttons, {bool isOperator = false, bool isMemory = false}) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildStyledButton(text, isOperator: isOperator, isMemory: isMemory),
            ),
          );
        }).toList(),
      ),
    );
  }


  // Helper final para estilizar o botão
  Widget _buildStyledButton(String text, {bool isOperator = false, bool isMemory = false}) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: isOperator
          ? Colors.orange
          : (isMemory ? Colors.blueGrey[700] : Colors.grey[300]),
      foregroundColor: isOperator || isMemory ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );

    return ElevatedButton(
      style: style,
      onPressed: () => _onButtonPressed(text),
      child: Text(text),
    );
  }
}