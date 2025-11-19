import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Dictionary',
      home: DictionaryScreen(),
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  // Controlador para o campo de texto (input)
  final TextEditingController _controller = TextEditingController();
  
  // Variáveis de estado
  String _definition = "Digite uma palavra em Inglês e clique em buscar.";
  bool _isLoading = false;

  // Função para buscar a definição na API
  Future<void> _fetchDefinition() async {
    final word = _controller.text.trim(); // Pega a palavra e remove espaços
    
    if (word.isEmpty) {
      setState(() {
        _definition = "Por favor, digite uma palavra.";
      });
      return;
    }

    setState(() {
      _isLoading = true; // Ativa o indicador de carregamento
      _definition = "Buscando...";
    });

    try {
      // Endpoint da API: https://api.dictionaryapi.dev/api/v2/entries/en/<word>
      final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Sucesso: Decodifica o JSON retornado (é uma lista)
        final List<dynamic> data = jsonDecode(response.body);
        
        // A API retorna uma lista de objetos. A definição está geralmente em:
        // data[0] -> 'meanings' -> [0] -> 'definitions' -> [0] -> 'definition'

        final definition = data[0]['meanings'][0]['definitions'][0]['definition'];
        
        setState(() {
          _definition = definition; // Atualiza a definição
        });

      } else if (response.statusCode == 404) {
        // Palavra não encontrada
        setState(() {
          _definition = "Palavra não encontrada. Tente novamente.";
        });
      } else {
        // Outros erros HTTP
        setState(() {
          _definition = "Erro ao buscar a API: ${response.statusCode}";
        });
      }
    } catch (e) {
      // Erro de conexão ou parsing
      setState(() {
        _definition = "Ocorreu um erro: Verifique sua conexão ou o formato dos dados. ($e)";
      });
    } finally {
      setState(() {
        _isLoading = false; // Desativa o carregamento no final, independente do resultado
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicionário Rápido'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Campo de entrada de texto
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite a palavra (ex: "hello", "book")',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _fetchDefinition(), // Permite buscar ao pressionar Enter
            ),
            const SizedBox(height: 10),
            
            // Botão de Busca
            ElevatedButton.icon(
              onPressed: _fetchDefinition,
              icon: const Icon(Icons.g_translate),
              label: const Text('Buscar Definição'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            
            const SizedBox(height: 30),

            // Exibição do estado (Loading, Definição ou Erro)
            Text(
              "Resultado:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
            ),
            const Divider(),
            
            // Exibição condicional do indicador de carregamento
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
                : Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _definition,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}