import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo de Cartas Star Wars',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CardGameScreen(),
    );
  }
}

// 1. MODELO DE DADOS CORRIGIDO: SwapiCharacter
class SwapiCharacter {
  final String name;
  final String height; // Altura
  final String mass; // Massa
  final String starshipSpeed; // Velocidade da nave (usando a primeira nave)

  SwapiCharacter({
    required this.name,
    required this.height,
    required this.mass,
    required this.starshipSpeed,
  });

  // Função utilitária para converter a string do API para um número comparável
  double getNumericValue(String attribute) {
    String valueString;
    if (attribute == 'Height') {
      valueString = height;
    } else if (attribute == 'Mass') {
      valueString = mass;
    } else if (attribute == 'Starship Speed') {
      valueString = starshipSpeed;
    } else {
      return 0.0;
    }

    // Limpa a string (remove vírgulas) e lida com 'unknown'
    valueString = valueString.replaceAll(',', '');
    if (valueString.toLowerCase() == 'unknown' || valueString.isEmpty) {
      return 0.0;
    }
    // Retorna o valor numérico (0.0 se falhar no parse)
    return double.tryParse(valueString) ?? 0.0;
  }
}

// 2. FUNÇÃO DE BUSCA DA API (SWAPI)
Future<SwapiCharacter?> fetchRandomCharacter() async {
  // Sortear ID entre 1 e 83 (o limite da SWAPI)
  final randomId = Random().nextInt(83) + 1;
  final url = Uri.parse('https://swapi.dev/api/people/$randomId/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // *** Buscando velocidade de Starship (segundo request, pode ser lento) ***
      String speed = '0';
      if (data['starships'] != null && data['starships'].isNotEmpty) {
        // Usa o primeiro link da starship para buscar a velocidade
        final starshipUrl = data['starships'][0];
        final starshipResponse = await http.get(Uri.parse(starshipUrl));
        if (starshipResponse.statusCode == 200) {
          final starshipData = jsonDecode(starshipResponse.body);
          speed = starshipData['max_atmosphering_speed'] ?? '0';
        }
      }

      // Se o personagem não tiver altura OU massa, retornamos nulo para tentar novamente
      if (data['height'] == 'unknown' || data['mass'] == 'unknown') return null;

      // Retorna o modelo SwapiCharacter correto
      return SwapiCharacter(
        name: data['name'] ?? 'Desconhecido',
        height: data['height'] ?? '0',
        mass: data['mass'] ?? '0',
        starshipSpeed: speed,
      );
    } else if (response.statusCode == 404) {
      // Se o ID não existir (ex: 17), tentamos buscar outro aleatoriamente
      return fetchRandomCharacter();
    } else {
      throw Exception('Falha ao carregar personagem: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint("Erro na requisição SWAPI: $e");
    return null;
  }
}


// WIDGET PRINCIPAL
class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key});

  @override
  State<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen> {
  // Modelos SwapiCharacter sendo usados
  SwapiCharacter? _playerCard;
  SwapiCharacter? _gameCard;
  String _currentStatus = "Clique em 'Jogar' para começar!";
  String? _chosenAttribute; 
  bool _isLoading = false;
  
  int _playerScore = 0;
  int _gameScore = 0;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // Função para carregar as cartas de forma síncrona
  void _loadCards() async {
    setState(() {
      _isLoading = true;
      _playerCard = null;
      _gameCard = null;
      _chosenAttribute = null;
      _currentStatus = "Buscando novos personagens...";
    });

    SwapiCharacter? pCard;
    SwapiCharacter? gCard;

    // Garante que o jogador pega um card válido (Looping até obter um 200 OK)
    while(pCard == null) {
      pCard = await fetchRandomCharacter();
    }
    // Garante que o jogo pega um card válido
    while(gCard == null) {
      gCard = await fetchRandomCharacter();
    }


    setState(() {
      _playerCard = pCard;
      _gameCard = gCard;
      _isLoading = false;
      
      _currentStatus = "Cartas carregadas! Pronto para jogar.";
    });
  }
  
  // Lógica da Checagem do Vencedor
  void _determineWinner() {
    if (_playerCard == null || _gameCard == null) return;
    
    final attributes = ['Height', 'Mass', 'Starship Speed'];
    final selectedAttr = attributes[Random().nextInt(attributes.length)];
    
    // Obtém os valores numéricos
    final playerValue = _playerCard!.getNumericValue(selectedAttr);
    final gameValue = _gameCard!.getNumericValue(selectedAttr);
    
    String resultMessage;
    
    if (playerValue > gameValue) {
      _playerScore++;
      resultMessage = "🎉 VOCÊ VENCEU! ($selectedAttr: ${playerValue.toStringAsFixed(1)} > ${gameValue.toStringAsFixed(1)})";
    } else if (gameValue > playerValue) {
      _gameScore++;
      resultMessage = "🤖 O JOGO VENCEU! ($selectedAttr: ${gameValue.toStringAsFixed(1)} > ${playerValue.toStringAsFixed(1)})";
    } else {
      resultMessage = "🤝 EMPATE! ($selectedAttr: ${playerValue.toStringAsFixed(1)} = ${gameValue.toStringAsFixed(1)})";
    }
    
    setState(() {
      _chosenAttribute = selectedAttr;
      _currentStatus = resultMessage;
    });
  }


  // --- WIDGETS DE EXIBIÇÃO ---
  
  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text("PLACAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("VOCÊ: $_playerScore", style: const TextStyle(color: Colors.yellowAccent, fontSize: 20)),
              Text("JOGO: $_gameScore", style: const TextStyle(color: Colors.yellowAccent, fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCard(SwapiCharacter? card, String title, bool isPlayer) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPlayer ? Colors.lightBlue.shade50 : Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isPlayer ? Colors.blue : Colors.indigo, width: 2),
          boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isPlayer ? Colors.blue.shade800 : Colors.indigo.shade800)),
            const Divider(),
            if (card != null) ...[
              Text(card.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              
              const Expanded(
                child: Center(
                  child: Icon(Icons.person_pin, size: 70, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 8),
              _buildAttributeRow("Height", "${card.height} cm", isPlayer),
              _buildAttributeRow("Mass", "${card.mass} kg", isPlayer),
              _buildAttributeRow("Starship Speed", "${card.starshipSpeed} km/h", isPlayer),
            ] else if (!_isLoading) ...[
              const Center(child: Text("Personagem indisponível")),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String attribute, String value, bool isPlayer) {
    final isChosen = attribute == _chosenAttribute;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(attribute, style: TextStyle(fontWeight: isChosen ? FontWeight.bold : FontWeight.normal, color: isChosen ? Colors.red.shade800 : Colors.black)),
          Text(value, style: TextStyle(fontWeight: isChosen ? FontWeight.bold : FontWeight.normal, color: isChosen ? Colors.red.shade800 : Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogo de Cartas Star Wars'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          // Contador (Scoreboard)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildScoreBoard(),
          ),
          
          // Cartas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  _buildCard(_gameCard, "Carta do Jogo (Esquerda)", false), 
                  _buildCard(_playerCard, "Sua Carta (Direita)", true), 
                ],
              ),
            ),
          ),
          
          // Área de Status e Botão
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  _currentStatus,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                
                // Botão de Ação
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _chosenAttribute == null ? _determineWinner : _loadCards,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _chosenAttribute == null ? Colors.green : Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Text(_chosenAttribute == null ? 'JOGAR!' : 'PRÓXIMA RODADA'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}