import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double alturaBotao = 80.0;
const Color fundo = Color(0xFF1E164B);
const Color ativo = Color(0xFF638ED6); // Cor para seleção ativa

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('IMC do Pet')),
        body: SafeArea(
  child: SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: IMCPage(),
    ),
  ),
),
      ),
    );
  }
}

class IMCPage extends StatefulWidget {
  @override
  _IMCPageState createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  String especieSelecionada = '';
  double altura = 30.0; // altura do pet em cm
  int peso = 5; // peso do pet em kg
  int idade = 1; // idade do pet em anos
  double imc = 0.0;
  int idadeFisiologica = 0;

  void calcularResultados() {
    setState(() {
      // Cálculo do IMC do pet (convertendo altura para metros)
      double alturaMetros = altura / 100;
      imc = peso / (alturaMetros * alturaMetros);

      // Cálculo da idade fisiológica
      if (especieSelecionada == 'GATO') {
        if (idade == 1) {
          idadeFisiologica = 15;
        } else if (idade == 2) {
          idadeFisiologica = 24;
        } else if (idade == 3) {
          idadeFisiologica = 28;
        } else if (idade == 4) {
          idadeFisiologica = 32;
        } else if (idade == 5) {
          idadeFisiologica = 36;
        } else {
          idadeFisiologica = 40 + (idade - 6) * 4;
        }
      } else if (especieSelecionada == 'CACHORRO') {
        if (peso <= 9) {
          idadeFisiologica = 15 + (idade - 1) * 4;
        } else if (peso <= 22) {
          idadeFisiologica = 15 + (idade - 1) * 5;
        } else {
          idadeFisiologica = 15 + (idade - 1) * 6;
        }
      } else {
        idadeFisiologica = 0;
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return ListView(
    children: [
      Row(
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
                  children: const [
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
                  children: const [
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
      Caixa(
        cor: fundo,
        filho: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Altura:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
            const SizedBox(height: 15),
            Text('${altura.round()} cm', style: const TextStyle(fontSize: 24.0, color: Colors.white)),
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
      Row(
        children: [
          Expanded(
            child: Caixa(
              cor: fundo,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Peso:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                  const SizedBox(height: 15),
                  Text('$peso kg', style: const TextStyle(fontSize: 24.0, color: Colors.white)),
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
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            peso++;
                          });
                        },
                        child: const Icon(Icons.add, color: Colors.white),
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
                  Text('$idade', style: const TextStyle(fontSize: 24.0, color: Colors.white)),
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
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            idade++;
                          });
                        },
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Caixa(
        cor: fundo,
        filho: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Resultado:', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
            const SizedBox(height: 15),
            Text(imc.toStringAsFixed(1), style: const TextStyle(fontSize: 24.0, color: Colors.white)),
          ],
        ),
      ),
      GestureDetector(
        onTap: calcularIMC,
        child: Container(
          color: const Color(0xFF638ED6),
          width: double.infinity,
          height: alturaBotao,
          margin: const EdgeInsets.all(10.0),
          child: const Center(
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
