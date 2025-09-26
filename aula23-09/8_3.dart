import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TreinamentoTabuada());
}

class TreinamentoTabuada extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treinamento de Tabuada',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaTabuada(),
    );
  }
}

class TelaTabuada extends StatefulWidget {
  @override
  _TelaTabuadaState createState() => _TelaTabuadaState();
}

class _TelaTabuadaState extends State<TelaTabuada> {
  int tabuadaAtual = 1;
  int multiplicadorAtual = 1;
  int totalAcertos = 0;
  TextEditingController controladorResposta = TextEditingController();

  // Carregar o progresso salvo
  Future<void> _carregarProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tabuadaAtual = prefs.getInt('tabuadaAtual') ?? 1;
      multiplicadorAtual = prefs.getInt('multiplicadorAtual') ?? 1;
      totalAcertos = prefs.getInt('totalAcertos') ?? 0;
    });
  }

  // Salvar o progresso atual
  Future<void> _salvarProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tabuadaAtual', tabuadaAtual);
    await prefs.setInt('multiplicadorAtual', multiplicadorAtual);
    await prefs.setInt('totalAcertos', totalAcertos);
  }

  // Verificar a resposta do usuário
  void _verificarResposta() {
    int resultadoCorreto = tabuadaAtual * multiplicadorAtual;
    String textoResposta = controladorResposta.text.trim();

    if (textoResposta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira uma resposta.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    int? respostaUsuario;
    try {
      respostaUsuario = int.parse(textoResposta);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resposta inválida. Digite apenas números.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (respostaUsuario == resultadoCorreto) {
      setState(() {
        totalAcertos++;
        if (multiplicadorAtual < 10) {
          multiplicadorAtual++;
        } else if (tabuadaAtual < 10) {
          tabuadaAtual++;
          multiplicadorAtual = 1;
        } else {
          // Exibir mensagem de conclusão
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Parabéns! Você completou todas as tabuadas!'),
              duration: Duration(seconds: 3),
            ),
          );
          tabuadaAtual = 1;
          multiplicadorAtual = 1;
          totalAcertos = 0;
        }
      });
      _salvarProgresso();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resposta errada, tente novamente!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    controladorResposta.clear();
  }

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento de Tabuada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tabuada do $tabuadaAtual',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Quanto é $tabuadaAtual x $multiplicadorAtual?',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: controladorResposta,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite sua resposta',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verificarResposta,
              child: Text('Enviar Resposta'),
            ),
            SizedBox(height: 20),
            Text(
              'Acertos: $totalAcertos',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}