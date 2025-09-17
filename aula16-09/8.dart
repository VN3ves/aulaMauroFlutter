import 'package:flutter/material.dart';

void main() {
  runApp(const AlunoApp());
}

class AlunoApp extends StatelessWidget {
  const AlunoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cadastro de Aluno',
      home: TelaInfoAluno(),
    );
  }
}

// --- TELA 1: Inserir Nome e Matrícula ---
class TelaInfoAluno extends StatefulWidget {
  const TelaInfoAluno({super.key});

  @override
  State<TelaInfoAluno> createState() => _TelaInfoAlunoState();
}

class _TelaInfoAlunoState extends State<TelaInfoAluno> {
  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();

  void _proximaTela() {
    if (_nomeController.text.isNotEmpty && _matriculaController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaLancamentoNotas(
            nome: _nomeController.text,
            matricula: _matriculaController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informações do Aluno')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome do Aluno')),
            const SizedBox(height: 10),
            TextField(controller: _matriculaController, decoration: const InputDecoration(labelText: 'Matrícula')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _proximaTela, child: const Text('Lançar Notas')),
          ],
        ),
      ),
    );
  }
}

// --- TELA 2: Lançar Notas ---
class TelaLancamentoNotas extends StatefulWidget {
  final String nome;
  final String matricula;

  const TelaLancamentoNotas({super.key, required this.nome, required this.matricula});

  @override
  State<TelaLancamentoNotas> createState() => _TelaLancamentoNotasState();
}

class _TelaLancamentoNotasState extends State<TelaLancamentoNotas> {
  final _notaController = TextEditingController();
  final List<double> _notas = [];

  void _adicionarNota() {
    final double? nota = double.tryParse(_notaController.text);
    if (nota != null) {
      setState(() {
        _notas.add(nota);
        _notaController.clear();
      });
      // Esconde o teclado após adicionar.
      FocusScope.of(context).unfocus();
    }
  }

  void _verResumo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResumoAluno(
          nome: widget.nome,
          matricula: widget.matricula,
          notas: _notas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notas de ${widget.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _notaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Digite a nota'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _adicionarNota, child: const Text('Adicionar Nota')),
            const SizedBox(height: 20),
            const Text('Notas Lançadas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Nota ${index + 1}: ${_notas[index]}'));
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _verResumo, child: const Text('Ver Resumo Final')),
          ],
        ),
      ),
    );
  }
}

// --- TELA 3: Resumo Final do Aluno ---
class TelaResumoAluno extends StatelessWidget {
  final String nome;
  final String matricula;
  final List<double> notas;

  const TelaResumoAluno({super.key, required this.nome, required this.matricula, required this.notas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Aluno')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $nome', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Matrícula: $matricula', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Notas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Nota: ${notas[index]}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}