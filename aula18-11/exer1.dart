import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaClima(),
    );
  }
}

class PaginaClima extends StatefulWidget {
  const PaginaClima({super.key});

  @override
  State<PaginaClima> createState() => _PaginaClimaState();
}

class _PaginaClimaState extends State<PaginaClima> {
  // Controlador para pegar o texto digitado
  TextEditingController controladorCidade = TextEditingController();

  // Variáveis para armazenar os dados
  String resultadoTexto = "Digite uma cidade para ver o clima.";
  bool carregando = false;

  // Variáveis específicas do clima
  double? temperatura;
  double? umidade;
  double? vento;

  // Função Principal: Busca Lat/Lon e depois o Clima
  Future<void> buscarClima() async {
    String cidade = controladorCidade.text;

    if (cidade.isEmpty) return;

    setState(() {
      carregando = true; // Ativa o CircularProgressIndicator
      resultadoTexto = "Buscando cidade...";
    });

    try {
      // PASSO 1: Buscar Latitude e Longitude (Geocoding API do Open-Meteo)
      final urlGeo = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$cidade&count=1&language=pt&format=json',
      );
      final responseGeo = await http.get(urlGeo);

      if (responseGeo.statusCode == 200) {
        final dadosGeo = jsonDecode(responseGeo.body);

        // Verifica se encontrou alguma cidade
        if (dadosGeo['results'] != null && dadosGeo['results'].isNotEmpty) {
          double lat = dadosGeo['results'][0]['latitude'];
          double lon = dadosGeo['results'][0]['longitude'];
          String nomeEncontrado = dadosGeo['results'][0]['name'];

          // PASSO 2: Buscar o Clima usando a Lat e Lon obtidas
          await buscarDadosMeteorologicos(lat, lon, nomeEncontrado);
        } else {
          setState(() {
            resultadoTexto = "Cidade não encontrada.";
            carregando = false;
          });
        }
      } else {
        throw Exception('Erro ao buscar cidade.');
      }
    } catch (e) {
      setState(() {
        resultadoTexto = "Erro: $e";
        carregando = false;
      });
    }
  }

  Future<void> buscarDadosMeteorologicos(
    double lat,
    double lon,
    String nomeCidade,
  ) async {
    // Monta a URL com as variáveis pedidas no exercício
    final urlClima = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m',
    );

    final responseClima = await http.get(urlClima);

    if (responseClima.statusCode == 200) {
      final dadosClima = jsonDecode(responseClima.body);

      // Acessando o JSON conforme seu resumo: resultado['current']['temperature_2m']
      final current = dadosClima['current'];

      setState(() {
        temperatura = current['temperature_2m']; // Temperatura
        umidade = (current['relative_humidity_2m'] as num)
            .toDouble(); // Umidade (às vezes vem int)
        vento = current['wind_speed_10m']; // Vento

        resultadoTexto = "Clima em $nomeCidade"; // Título
        carregando = false; // Desativa o loading
      });
    } else {
      setState(() {
        resultadoTexto = "Erro ao buscar dados do clima.";
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previsão do Tempo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField Decorado (Conforme Item 5 do seu resumo)
            TextField(
              controller: controladorCidade,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                icon: Icon(Icons.location_city, color: Colors.blue),
                hintText: 'Ex: São Paulo',
                labelText: 'Nome da cidade (Não aceita acentos)',
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: buscarClima,
              child: const Text("Buscar Clima"),
            ),

            const SizedBox(height: 40),

            // Lógica de Exibição (Loading ou Dados)
            carregando
                ? const CircularProgressIndicator() // Item 3 do resumo
                : Column(
                    children: [
                      Text(
                        resultadoTexto,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (temperatura != null) ...[
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.thermostat,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "Temperatura: $temperatura °C",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.water_drop,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Umidade: $umidade %",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.air, color: Colors.grey),
                                    Text(
                                      "Vento: $vento km/h",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
