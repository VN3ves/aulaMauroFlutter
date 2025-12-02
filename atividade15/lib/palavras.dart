import 'package:flutter/material.dart';
import 'package:aula04_11/db_helper.dart';

class LearnedWordsPage extends StatefulWidget {
  const LearnedWordsPage({super.key});

  @override
  State<LearnedWordsPage> createState() => _LearnedWordsPageState();
}

class _LearnedWordsPageState extends State<LearnedWordsPage> {
  final DbHelper _dbHelper = DbHelper();
  Future<List<String>>? _learnedWordsFuture;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() {
    setState(() {
      _learnedWordsFuture = _dbHelper.getLearnedWords();
    });
  }
  
  Future<void> _unlearnWord(String word) async {
    await _dbHelper.removeWord(word);
    _loadWords();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Palavra "$word" removida da lista.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Vocabulário'),
      ),
      body: FutureBuilder<List<String>>(
        future: _learnedWordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final words = snapshot.data ?? [];

          if (words.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: theme.colorScheme.secondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhuma palavra aprendida ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Marque palavras como "Entendi" ao ler os textos.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    child: const Icon(Icons.check, color: Colors.green),
                  ),
                  title: Text(
                    word,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Esquecer palavra',
                    onPressed: () => _unlearnWord(word),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}