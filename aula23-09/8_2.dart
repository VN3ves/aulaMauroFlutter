import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(QuizConhecimentosGerais());
}

class QuizConhecimentosGerais extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz de Conhecimentos Gerais',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaQuiz(),
    );
  }
}

class TelaQuiz extends StatefulWidget {
  @override
  _TelaQuizState createState() => _TelaQuizState();
}

class _TelaQuizState extends State<TelaQuiz> {
  int indicePerguntaAtual = 0;
  int pontuacaoUsuario = 0;

  final List<Map<String, Object>> perguntasSelecionadas = [
    {
      'pergunta': 'Qual é a capital da França?',
      'opcoes': ['Berlim', 'Madrid', 'Paris', 'Roma'],
      'respostaCorreta': 2,
    },
    {
      'pergunta': 'Quem escreveu "Dom Quixote"?',
      'opcoes': ['William Shakespeare', 'Miguel de Cervantes', 'Gabriel García Márquez', 'Fiódor Dostoiévski'],
      'respostaCorreta': 1,
    },
    {
      'pergunta': 'Qual é o maior planeta do sistema solar?',
      'opcoes': ['Terra', 'Marte', 'Júpiter', 'Saturno'],
      'respostaCorreta': 2,
    },
    {
      'pergunta': 'Quem pintou a Mona Lisa?',
      'opcoes': ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Claude Monet'],
      'respostaCorreta': 2,
    },
    {
      'pergunta': 'Qual é o rio mais longo do mundo?',
      'opcoes': ['Rio Amazonas', 'Rio Nilo', 'Rio Yangtzé', 'Rio Mississippi'],
      'respostaCorreta': 0, // Amazonas é o mais longo
    },
    {
      'pergunta': 'Qual é o país mais populoso do mundo?',
      'opcoes': ['Índia', 'Estados Unidos', 'China', 'Indonésia'],
      'respostaCorreta': 0, // Índia superou a China em 2023
    },
    {
      'pergunta': 'Qual é o maior oceano do mundo?',
      'opcoes': ['Oceano Atlântico', 'Oceano Índico', 'Oceano Ártico', 'Oceano Pacífico'],
      'respostaCorreta': 3,
    },
    {
      'pergunta': 'Quem descobriu a América em 1492?',
      'opcoes': ['Vasco da Gama', 'Cristóvão Colombo', 'Fernão de Magalhães', 'James Cook'],
      'respostaCorreta': 1,
    },
    {
      'pergunta': 'Qual é o esporte mais popular do mundo?',
      'opcoes': ['Basquete', 'Futebol', 'Tênis', 'Críquete'],
      'respostaCorreta': 1,
    },
    {
      'pergunta': 'Qual é a capital do Canadá?',
      'opcoes': ['Toronto', 'Vancouver', 'Ottawa', 'Montreal'],
      'respostaCorreta': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarProgressoQuiz();
  }

  // Carrega o progresso salvo do quiz
  Future<void> _carregarProgressoQuiz() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      indicePerguntaAtual = prefs.getInt('indicePerguntaAtual') ?? 0;
      pontuacaoUsuario = prefs.getInt('pontuacaoUsuario') ?? 0;
      // Reseta se o índice salvo ultrapassar o número de perguntas
      if (indicePerguntaAtual >= perguntasSelecionadas.length) {
        indicePerguntaAtual = 0;
        pontuacaoUsuario = 0;
      }
    });
  }

  // Salva o progresso atual do quiz
  Future<void> _salvarProgressoQuiz() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('indicePerguntaAtual', indicePerguntaAtual);
    await prefs.setInt('pontuacaoUsuario', pontuacaoUsuario);
  }

  void avaliarResposta(int escolhaSelecionada) {
    if (escolhaSelecionada == perguntasSelecionadas[indicePerguntaAtual]['respostaCorreta']) {
      pontuacaoUsuario++;
    }
    _salvarProgressoQuiz(); // Salva o estado após cada resposta
    setState(() {
      if (indicePerguntaAtual < perguntasSelecionadas.length - 1) {
        indicePerguntaAtual++;
      } else {
        _exibirResultados();
      }
    });
  }

  void _exibirResultados() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultado do Quiz'),
        content: Text('Você acertou $pontuacaoUsuario de ${perguntasSelecionadas.length} perguntas!'),
        actions: [
          TextButton(
            child: Text('Reiniciar'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                pontuacaoUsuario = 0;
                indicePerguntaAtual = 0;
              });
              _salvarProgressoQuiz(); // Salva o estado resetado
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
              perguntasSelecionadas[indicePerguntaAtual]['pergunta'] as String,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...(perguntasSelecionadas[indicePerguntaAtual]['opcoes'] as List<String>).map((opcao) {
              int indice = (perguntasSelecionadas[indicePerguntaAtual]['opcoes'] as List<String>).indexOf(opcao);
              return ElevatedButton(
                onPressed: () => avaliarResposta(indice),
                child: Text(opcao),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}