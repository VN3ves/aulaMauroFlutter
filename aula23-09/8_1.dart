import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GeneralKnowledgeQuiz());
}

class GeneralKnowledgeQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'General Knowledge Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizHome(),
    );
  }
}

class QuizHome extends StatefulWidget {
  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  int currentQuestionIndex = 0;
  int userScore = 0;
  late List<Map<String, Object>> randomizedQuiz;

  final List<Map<String, Object>> questionPool = [
    {
      'prompt': 'Qual é a capital da França?',
      'choices': ['Berlim', 'Madrid', 'Paris', 'Roma'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Quem escreveu "Dom Quixote"?',
      'choices': ['William Shakespeare', 'Miguel de Cervantes', 'Gabriel García Márquez', 'Fiódor Dostoiévski'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o maior planeta do sistema solar?',
      'choices': ['Terra', 'Marte', 'Júpiter', 'Saturno'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Em que ano ocorreu a Revolução Francesa?',
      'choices': ['1776', '1789', '1812', '1848'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Quem pintou a Mona Lisa?',
      'choices': ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Claude Monet'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Qual é o elemento químico representado pelo símbolo "O"?',
      'choices': ['Ouro', 'Oxigênio', 'Osmium', 'Ósmio'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o rio mais longo do mundo?',
      'choices': ['Rio Amazonas', 'Rio Nilo', 'Rio Yangtzé', 'Rio Mississippi'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Quem foi o primeiro presidente dos Estados Unidos?',
      'choices': ['Abraham Lincoln', 'Thomas Jefferson', 'George Washington', 'John Adams'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Qual é o país mais populoso do mundo?',
      'choices': ['Índia', 'Estados Unidos', 'China', 'Indonésia'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Qual é a fórmula química da água?',
      'choices': ['CO2', 'H2O', 'O2', 'NaCl'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Quem é conhecido como o "Pai da Física"?',
      'choices': ['Isaac Newton', 'Albert Einstein', 'Galileo Galilei', 'Nikola Tesla'],
      'correctChoice': 0,
    },
    {
      'prompt': 'Qual é o maior oceano do mundo?',
      'choices': ['Oceano Atlântico', 'Oceano Índico', 'Oceano Ártico', 'Oceano Pacífico'],
      'correctChoice': 3,
    },
    {
      'prompt': 'Quem descobriu a América em 1492?',
      'choices': ['Vasco da Gama', 'Cristóvão Colombo', 'Fernão de Magalhães', 'James Cook'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é a moeda oficial do Japão?',
      'choices': ['Yuan', 'Won', 'Yen', 'Dólar'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Quem foi o autor de "Romeu e Julieta"?',
      'choices': ['Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o país conhecido como a terra dos cangurus?',
      'choices': ['Nova Zelândia', 'África do Sul', 'Canadá', 'Austrália'],
      'correctChoice': 3,
    },
    {
      'prompt': 'Qual é o nome do maior deserto do mundo?',
      'choices': ['Deserto do Saara', 'Deserto de Gobi', 'Deserto da Arábia', 'Deserto da Antártica'],
      'correctChoice': 3,
    },
    {
      'prompt': 'Quem foi o cientista que propôs a teoria da relatividade?',
      'choices': ['Isaac Newton', 'Albert Einstein', 'Niels Bohr', 'Marie Curie'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o esporte mais popular do mundo?',
      'choices': ['Basquete', 'Futebol', 'Tênis', 'Críquete'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é a língua mais falada no mundo?',
      'choices': ['Inglês', 'Espanhol', 'Mandarim', 'Hindi'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Quem foi o primeiro homem a pisar na Lua?',
      'choices': ['Yuri Gagarin', 'Buzz Aldrin', 'Neil Armstrong', 'Michael Collins'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Qual é o nome do autor de "O Pequeno Príncipe"?',
      'choices': ['Antoine de Saint-Exupéry', 'J.K. Rowling', 'Lewis Carroll', 'Hans Christian Andersen'],
      'correctChoice': 0,
    },
    {
      'prompt': 'Qual é a capital do Canadá?',
      'choices': ['Toronto', 'Vancouver', 'Ottawa', 'Montreal'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Quem pintou "A Noite Estrelada"?',
      'choices': ['Claude Monet', 'Vincent van Gogh', 'Pablo Picasso', 'Salvador Dalí'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o nome do processo pelo qual as plantas produzem alimento?',
      'choices': ['Respiração', 'Fotossíntese', 'Fermentação', 'Digestão'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o nome do maior mamífero terrestre?',
      'choices': ['Elefante Africano', 'Baleia Azul', 'Rinoceronte', 'Hipopótamo'],
      'correctChoice': 0,
    },
    {
      'prompt': 'Qual é o nome do famoso físico que desenvolveu a lei da gravitação universal?',
      'choices': ['Albert Einstein', 'Isaac Newton', 'Stephen Hawking', 'Galileo Galilei'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o nome do autor de "Cem Anos de Solidão"?',
      'choices': ['Jorge Luis Borges', 'Gabriel García Márquez', 'Mario Vargas Llosa', 'Isabel Allende'],
      'correctChoice': 1,
    },
    {
      'prompt': 'Qual é o nome do maior continente do mundo?',
      'choices': ['África', 'América do Norte', 'Ásia', 'Europa'],
      'correctChoice': 2,
    },
    {
      'prompt': 'Qual é o nome do famoso festival de música realizado em Indio, Califórnia?',
      'choices': ['Glastonbury', 'Coachella', 'Lollapalooza', 'Rock in Rio'],
      'correctChoice': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    randomizedQuiz = _randomizeQuestions();
  }

  List<Map<String, Object>> _randomizeQuestions() {
    final random = Random();
    List<Map<String, Object>> tempPool = List.from(questionPool);
    tempPool.shuffle(random);
    return tempPool.take(10).toList();
  }

  void evaluateAnswer(int selectedChoice) {
    if (selectedChoice == randomizedQuiz[currentQuestionIndex]['correctChoice']) {
      userScore++;
    }
    setState(() {
      if (currentQuestionIndex < randomizedQuiz.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultados do Quiz'),
        content: Text('Você acertou $userScore de ${randomizedQuiz.length} perguntas!'),
        actions: [
          TextButton(
            child: Text('Reiniciar'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                userScore = 0;
                currentQuestionIndex = 0;
                randomizedQuiz = _randomizeQuestions();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz de Conhecimentos Gerais'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              randomizedQuiz[currentQuestionIndex]['prompt'] as String,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...(randomizedQuiz[currentQuestionIndex]['choices'] as List<String>).map((choice) {
              int index = (randomizedQuiz[currentQuestionIndex]['choices'] as List<String>).indexOf(choice);
              return ElevatedButton(
                onPressed: () => evaluateAnswer(index),
                child: Text(choice),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}