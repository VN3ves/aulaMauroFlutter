import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class DefinitionPage extends StatefulWidget {
  final String word;

  const DefinitionPage({super.key, required this.word});

  @override
  State<DefinitionPage> createState() => _DefinitionPageState();
}

class _DefinitionPageState extends State<DefinitionPage> {
  Map<String, dynamic>? _definitionData;
  bool _isLoading = true;
  String _errorMessage = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchDefinition();
  }

  Future<void> _fetchDefinition() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _definitionData = null;
    });

    final url =
        'https://api.dictionaryapi.dev/api/v2/entries/en/${widget.word}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _definitionData = data[0];
          });
        } else {
          setState(() {
            _errorMessage = 'Nenhuma definição encontrada.';
          });
        }
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['title'] ?? 'Definição não encontrada';
          if (errorData.containsKey('message')) {
            _errorMessage += '\n\n${errorData['message']}';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ${response.statusCode} ao buscar a definição.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Falha na conexão: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playPronunciation(String? audioUrl) async {
    if (audioUrl == null || audioUrl.isEmpty) return;

    try {
      await _audioPlayer.play(DeviceFileSource(audioUrl));
    } catch (e) {
      await _audioPlayer.play(UrlSource(audioUrl));
    }
  }

  String? _getAudioUrl(Map<String, dynamic>? data) {
    if (data == null || !data.containsKey('phonetics')) return null;

    final List phonetics = data['phonetics'] as List? ?? [];

    for (var p in phonetics) {
      final audio = p['audio'] as String? ?? '';
      if (audio.endsWith('-us.mp3')) {
        return audio.startsWith('//') ? 'https:$audio' : audio;
      }
    }

    for (var p in phonetics) {
      final audio = p['audio'] as String? ?? '';
      if (audio.isNotEmpty) {
        return audio.startsWith('//') ? 'https:$audio' : audio;
      }
    }

    return null;
  }

  void _showNoAudioMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Áudio de pronúncia indisponível para esta palavra.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.word.toUpperCase())),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              ),
            )
          : _definitionData == null
          ? const Center(child: Text('Dados inválidos.'))
          : _buildDefinitionView(context),
    );
  }

  Widget _buildDefinitionView(BuildContext context) {
    final theme = Theme.of(context);
    final String? audioUrl = _getAudioUrl(_definitionData);
    final bool hasAudio = audioUrl != null;

    final List meanings = _definitionData!['meanings'] as List? ?? [];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.word,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton.filledTonal(
                          icon: Icon(
                            hasAudio
                                ? Icons.volume_up
                                : Icons.volume_off,
                            size: 28,
                            color: hasAudio ? null : Colors.grey,
                          ),
                          onPressed: () {
                            if (hasAudio) {
                              _playPronunciation(audioUrl);
                            } else {
                              _showNoAudioMessage();
                            }
                          },
                          tooltip: hasAudio
                              ? 'Ouvir Pronúncia'
                              : 'Sem áudio disponível',
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    if (meanings.isEmpty)
                      const Text('Sem definições disponíveis.'),

                    ...meanings.map<Widget>((m) {
                      final partOfSpeech =
                          m['partOfSpeech'] as String? ?? 'N/A';
                      final definitions = m['definitions'] as List? ?? [];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                partOfSpeech,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...definitions
                                .map<Widget>((d) {
                                  final definition =
                                      d['definition'] as String? ?? '';
                                  final example = d['example'] as String?;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12.0,
                                      left: 4.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '• ',
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                definition,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (example != null &&
                                            example.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20.0,
                                              top: 6.0,
                                            ),
                                            child: Text(
                                              '"$example"',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey[700],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                })
                                .take(3),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 56),
            ),
            icon: const Icon(Icons.check_circle),
            label: const Text(
              'Já Entendi Essa Palavra',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
