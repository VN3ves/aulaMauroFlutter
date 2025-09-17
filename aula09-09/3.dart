import 'package:flutter/material.dart';
import 'dart:math';

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
  String _imagemMaquina = 'assets/imagens/padrao.png';
  String _mensagem = 'Faça sua escolha!';
  
  int _contadorJogadas = 0;

  void _jogar(String escolhaJogador) {
    _contadorJogadas++;
    String escolhaMaquina;

    if (_contadorJogadas % 5 == 0) {
      if (escolhaJogador == 'pedra') {
        escolhaMaquina = 'tesoura';
      } else if (escolhaJogador == 'papel') {
        escolhaMaquina = 'pedra';
      } else { // jogador escolheu tesoura
        escolhaMaquina = 'papel';
      }
    } else {
      if (escolhaJogador == 'pedra') {
        escolhaMaquina = ['pedra', 'papel'][Random().nextInt(2)];
      } else if (escolhaJogador == 'papel') {
        escolhaMaquina = ['papel', 'tesoura'][Random().nextInt(2)];
      } else { // jogador escolheu tesoura
        escolhaMaquina = ['tesoura', 'pedra'][Random().nextInt(2)];
      }
    }
    
    setState(() {
      _imagemMaquina = 'assets/imagens/$escolhaMaquina.png';
    });

    if ((escolhaJogador == 'pedra' && escolhaMaquina == 'tesoura') ||
        (escolhaJogador == 'papel' && escolhaMaquina == 'pedra') ||
        (escolhaJogador == 'tesoura' && escolhaMaquina == 'papel')) {
      setState(() => _mensagem = 'Parabéns, você ganhou! 🎉');
    } else if (escolhaJogador == escolhaMaquina) {
      setState(() => _mensagem = 'Ocorreu um empate! 😐');
    } else {
      setState(() => _mensagem = 'Que pena, a máquina ganhou! 🤖');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedra, Papel e Tesoura (Viciado)'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text("Jogada Nº $_contadorJogadas", style: TextStyle(color: Colors.grey[600])),
            ),
            const Text('Escolha da Máquina', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Image.asset(_imagemMaquina, height: 120),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(_mensagem, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            ),
            const Text('Sua Escolha', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(onTap: () => _jogar('pedra'), child: Image.asset('assets/imagens/pedra.png', height: 100)),
                GestureDetector(onTap: () => _jogar('papel'), child: Image.asset('assets/imagens/papel.png', height: 100)),
                GestureDetector(onTap: () => _jogar('tesoura'), child: Image.asset('assets/imagens/tesoura.png', height: 100)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}