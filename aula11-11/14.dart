import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _carregando = true;
  String? _erro;

  double? _latitude;
  double? _longitude;

  double? _temperatura;
  int? _umidade;
  double? _velocidadeVento;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<Position> _getPosicao() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('As permissões de localização foram negadas.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'As permissões de localização foram negadas permanentemente.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> _getClima(double lat, double lon) async {
    final String url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m&wind_speed_unit=ms';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar dados do clima. (${response.body})');
    }
  }

  void _carregarDados() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      Position position = await _getPosicao();
      _latitude = position.latitude;
      _longitude = position.longitude;

      Map<String, dynamic> dataClima = await _getClima(_latitude!, _longitude!);

      setState(() {
        _temperatura = dataClima['current']['temperature_2m'];
        _umidade = dataClima['current']['relative_humidity_2m'];
        _velocidadeVento = dataClima['current']['wind_speed_10m'];
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Widget _buildConteudo() {
    if (_carregando) {
      return const CircularProgressIndicator();
    }

    if (_erro != null) {
      return Text(
        _erro!,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Localização: $_latitude, $_longitude',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          'Temperatura: ${_temperatura?.toStringAsFixed(1) ?? 'N/A'} °C',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          'Umidade: ${_umidade ?? 'N/A'} %',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          'Vento: ${_velocidadeVento?.toStringAsFixed(1) ?? 'N/A'} m/s',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clima Atual (Open-Meteo)'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _carregarDados,
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildConteudo(),
          ),
        ),
      ),
    );
  }
}
