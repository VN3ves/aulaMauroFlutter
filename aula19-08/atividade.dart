import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  // Função para criar um card de verbo
  // Recebe os dados do verbo e retorna um widget Card configurado
  Card criaFlashcard(String verbo, String urlImagem, String frasePassado,
      String frasePresente, String fraseFuturo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4, // Adiciona uma sombra para destacar o card
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagem ilustrativa do verbo
            Center(
              child: Image.network(
                urlImagem,
                height: 150,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 12), // Espaçamento

            // Título do verbo
            Text(
              verbo,
              style: GoogleFonts.rampartOne(fontSize: 28),
            ),
            const SizedBox(height: 10),

            // Linha para o tempo Passado
            Row(
              children: <Widget>[
                const Icon(Icons.history, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(child: Text(frasePassado, style: GoogleFonts.quicksand())),
              ],
            ),
            const SizedBox(height: 8),

            // Linha para o tempo Presente
            Row(
              children: <Widget>[
                const Icon(Icons.wb_sunny, color: Colors.orangeAccent),
                const SizedBox(width: 8),
                Expanded(child: Text(frasePresente, style: GoogleFonts.quicksand())),
              ],
            ),
            const SizedBox(height: 8),

            // Linha para o tempo Futuro
            Row(
              children: <Widget>[
                const Icon(Icons.event, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(fraseFuturo, style: GoogleFonts.quicksand())),
              ],
            ),
            const SizedBox(height: 12),

            // Botão "Memorizado" alinhado à direita
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text('Memorizado'),
                onPressed: () {
                  // Ação do botão (pode ser implementada no futuro)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flashcards de Verbos'),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView( // Permite rolar a tela
          child: Center(
            child: Column(
              children: <Widget>[
                // Card 1: To Run
                criaFlashcard(
                  'To Run',
                  'https://images.pexels.com/photos/115740/pexels-photo-115740.jpeg',
                  'Yesterday, she ran a marathon.',
                  'He runs every morning to stay fit.',
                  'They will run a race next week.',
                ),
                // Linha horizontal para separar os cards
                const SizedBox(
                  width: 300,
                  child: Divider(color: Colors.grey, thickness: 1),
                ),

                // Card 2: To Eat
                criaFlashcard(
                  'To Eat',
                  'https://images.pexels.com/photos/3184183/pexels-photo-3184183.jpeg',
                  'I ate a delicious salad for lunch.',
                  'The family eats dinner together.',
                  'We will eat at the new restaurant.',
                ),
                // Linha horizontal para separar os cards
                const SizedBox(
                  width: 300,
                  child: Divider(color: Colors.grey, thickness: 1),
                ),

                // Card 3: To Write
                criaFlashcard(
                  'To Write',
                  'https://images.pexels.com/photos/4050318/pexels-photo-4050318.jpeg',
                  'He wrote a letter to his friend.',
                  'She writes in her journal every day.',
                  'I will write the report tomorrow.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}