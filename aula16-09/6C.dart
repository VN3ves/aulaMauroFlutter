import 'package:flutter/material.dart';

void main() {
  runApp(const IdadeApp());
}

class IdadeApp extends StatelessWidget {
  const IdadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cálculo de Idade',
      home: TelaDataNascimento(),
    );
  }
}

// --- TELA 1: Selecionar a Data de Nascimento ---
class TelaDataNascimento extends StatefulWidget {
  const TelaDataNascimento({super.key});

  @override
  State<TelaDataNascimento> createState() => _TelaDataNascimentoState();
}

class _TelaDataNascimentoState extends State<TelaDataNascimento> {
  DateTime? _dataNascimento;

  void _selecionarData() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        _dataNascimento = dataSelecionada;
      });
    }
  }

  void _calcularEExibirIdade() {
    if (_dataNascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma data!')),
      );
      return;
    }

    final DateTime hoje = DateTime.now();
    int idade = hoje.year - _dataNascimento!.year;
    // Ajusta a idade caso o aniversário ainda não tenha ocorrido no ano atual.
    if (hoje.month < _dataNascimento!.month ||
        (hoje.month == _dataNascimento!.month && hoje.day < _dataNascimento!.day)) {
      idade--;
    }

    // Navega para a segunda tela, passando a idade.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaIdade(idade: idade)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Idade')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _dataNascimento == null
                  ? 'Nenhuma data selecionada'
                  : 'Data: ${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selecionarData,
              child: const Text('Selecionar Data de Nascimento'),
            ),
            const SizedBox(height: 20),
            // Só mostra o botão de calcular se uma data foi escolhida.
            if (_dataNascimento != null)
              ElevatedButton(
                onPressed: _calcularEExibirIdade,
                child: const Text('Calcular Idade'),
              ),
          ],
        ),
      ),
    );
  }
}

// --- TELA 2: Exibir a Idade ---
class TelaIdade extends StatelessWidget {
  final int idade;

  const TelaIdade({super.key, required this.idade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sua Idade')),
      body: Center(
        child: Text(
          'Você tem ${idade.toString()} anos.',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}