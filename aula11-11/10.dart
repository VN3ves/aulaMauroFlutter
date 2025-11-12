import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Localizacao {
  double? latitude;
  double? longitude;

  Future<void> pegaLocalizacaoAtual() async {
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

    Position position = await Geolocator.getCurrentPosition();

    latitude = position.latitude;
    longitude = position.longitude;
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Localizacao _localizacao = Localizacao();
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarLocalizacao();
  }

  void _carregarLocalizacao() async {
    try {
      await _localizacao.pegaLocalizacaoAtual();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Busca Local'),
              const SizedBox(height: 16),

              _carregando
                  ? const CircularProgressIndicator()
                  : _erro != null
                  ? Text('Erro: $_erro')
                  : Column(
                      children: [
                        Text('Latitude: ${_localizacao.latitude ?? 'N/A'}'),
                        Text('Longitude: ${_localizacao.longitude ?? 'N/A'}'),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
