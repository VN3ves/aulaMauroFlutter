import 'package:flutter/material.dart';

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
  // Vetor de imagens (URLs da internet, como pedido no exercício)
  // Nota: A segunda URL estava quebrada, substituí por uma funcional.
  var imagens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg', // Pedra
    'https://www.collinsdictionary.com/images/full/paper_111691001.jpg', // Papel
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'  // Tesoura
  ];

  // Variável de estado para controlar qual imagem está sendo exibida.
  var _indiceAtual = 0;

  void _proximaImagem() {
    // setState avisa o Flutter para redesenhar a tela com o novo valor.
    setState(() {
      // Usamos o operador de módulo (%) para garantir que o índice sempre volte a 0
      // depois de chegar ao final da lista.
      _indiceAtual = (_indiceAtual + 1) % imagens.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedra, Papel e Tesoura - Exibidor'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imagens[_indiceAtual], // Exibe a imagem baseada no índice atual
              height: 200, // Define uma altura para a imagem
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _proximaImagem,
              child: const Text('Escolher', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}