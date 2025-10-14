import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double alturaBotao = 80.0;
const Color fundo = Color(0xFF1E164B);
const Color ativo = Color(0xFF638ED6); // Cor para gênero selecionado

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('IMC')),
        body: IMCPage(),
      ),
    );
  }
}

class IMCPage extends StatefulWidget {
  @override
  _IMCPageState createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  String generoSelecionado = '';
  double altura = 150.0; // em cm
  int peso = 65;
  int idade = 25; // Adicionei idade para completar o layout (baseado em apps típicos)
  double imc = 0.0;

  void calcularIMC() {
    setState(() {
      double alturaMetros = altura / 100;
      imc = peso / (alturaMetros * alturaMetros);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Caixa(
                  cor: generoSelecionado == 'MASC' ? ativo : fundo,
                  filho: GestureDetector(
                    onTap: () {
                      setState(() {
                        generoSelecionado = 'MASC';
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.male, color: Colors.white, size: 80.0),
                        SizedBox(height: 15),
                        Text('MASC', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Caixa(
                  cor: generoSelecionado == 'FEM' ? ativo : fundo,
                  filho: GestureDetector(
                    onTap: () {
                      setState(() {
                        generoSelecionado = 'FEM';
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.female, color: Colors.white, size: 80.0),
                        SizedBox(height: 15),
                        Text('FEM', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Caixa(
            cor: fundo,
            filho: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Altura:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                const SizedBox(height: 15),
                Text('${altura.round()} cm', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                Slider(
                  value: altura,
                  min: 100.0,
                  max: 200.0,
                  onChanged: (double valor) {
                    setState(() {
                      altura = valor;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Caixa(
                  cor: fundo,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Peso:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      const SizedBox(height: 15),
                      Text('$peso kg', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (peso > 0) peso--;
                              });
                            },
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                peso++;
                              });
                            },
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Caixa(
                  cor: fundo,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Idade:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      const SizedBox(height: 15),
                      Text('$idade', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (idade > 0) idade--;
                              });
                            },
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                idade++;
                              });
                            },
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Caixa(
                  cor: fundo,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Resultado:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      const SizedBox(height: 15),
                      Text(imc.toStringAsFixed(1), style: TextStyle(fontSize: 24.0, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              // Adicionei uma caixa extra se necessário, mas foquei no essencial
            ],
          ),
        ),
        GestureDetector(
          onTap: calcularIMC,
          child: Container(
            color: Color(0xFF638ED6),
            width: double.infinity,
            height: alturaBotao,
            margin: EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text('Calcular IMC', style: TextStyle(fontSize: 20.0, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}