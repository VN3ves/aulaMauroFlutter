import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const JogoApp());
}

class JogoApp extends StatelessWidget {
  const JogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Jogo(),
    );
  }
}

class Jogo extends StatefulWidget {
  const Jogo({super.key});

  @override
  State<Jogo> createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  final Map<String, String> _opcoes = {
    'pedra': 'assets/imagens/pedra.png',
    'papel': 'assets/imagens/papel.png',
    'tesoura': 'assets/imagens/tesoura.png',
  };

  // Variáveis de estado
  String _imagemMaquina = 'assets/imagens/padrao.png';
  String _mensagem = 'Faça sua escolha!';
  int _contadorJogadas = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _tocarSom(String nomeSom) {
    _audioPlayer.play(AssetSource('sons/$nomeSom'));
  }

  void _jogar(String escolhaJogador) {
    _tocarSom('clique.mp3');
    _contadorJogadas++;

    final opcoes = ['pedra', 'papel', 'tesoura'];
    String escolhaMaquina;

    if (_contadorJogadas % 5 == 0) {
      if (escolhaJogador == 'pedra') escolhaMaquina = 'tesoura';
      else if (escolhaJogador == 'papel') escolhaMaquina = 'pedra';
      else escolhaMaquina = 'papel';
    } else {
      if (escolhaJogador == 'pedra') escolhaMaquina = ['pedra', 'papel'][Random().nextInt(2)];
      else if (escolhaJogador == 'papel') escolhaMaquina = ['papel', 'tesoura'][Random().nextInt(2)];
      else escolhaMaquina = ['tesoura', 'pedra'][Random().nextInt(2)];
    }
    
    setState(() {
      _imagemMaquina = _opcoes[escolhaMaquina]!;
    });

    if ((escolhaJogador == 'pedra' && escolhaMaquina == 'tesoura') ||
        (escolhaJogador == 'papel' && escolhaMaquina == 'pedra') ||
        (escolhaJogador == 'tesoura' && escolhaMaquina == 'papel')) {
      setState(() => _mensagem = 'Parabéns, você ganhou! 🎉');
      _tocarSom('vitoria.mp3');
    } else if (escolhaJogador == escolhaMaquina) {
      setState(() => _mensagem = 'Ocorreu um empate! 😐');
      _tocarSom('empate.mp3');
    } else {
      setState(() => _mensagem = 'Que pena, a máquina ganhou! 🤖');
      _tocarSom('derrota.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedra, Papel e Tesoura'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text('Escolha da Máquina', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Image.asset(_imagemMaquina, height: 120),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(_mensagem, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
            ),
            const Text('Sua Escolha', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(onTap: () => _jogar('pedra'), child: Image.asset(_opcoes['pedra']!, height: 100)),
                GestureDetector(onTap: () => _jogar('papel'), child: Image.asset(_opcoes['papel']!, height: 100)),
                GestureDetector(onTap: () => _jogar('tesoura'), child: Image.asset(_opcoes['tesoura']!, height: 100)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}