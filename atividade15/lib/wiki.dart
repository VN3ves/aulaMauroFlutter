import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:aula04_11/definicao.dart';
import 'package:aula04_11/db_helper.dart';

typedef WordStatusChanged = void Function();

class WikiReaderPage extends StatefulWidget {
  final WordStatusChanged onWordStatusChanged;
  final List<String> learnedWords;

  const WikiReaderPage({
    super.key,
    required this.onWordStatusChanged,
    required this.learnedWords,
  });

  @override
  State<WikiReaderPage> createState() => _WikiReaderPageState();
}

class _WikiReaderPageState extends State<WikiReaderPage> {
  final TextEditingController _urlController = TextEditingController();
  final DbHelper _dbHelper = DbHelper();
  String _pageTitle = 'WikiReader English';
  String _pageContent = 'Cole um link e clique em Ler Agora.';
  bool _isLoading = false;
  bool _hasContent = false;

  Future<void> _fetchAndParseWikipedia() async {
    String url = _urlController.text.trim();

    if (url.isEmpty) {
      _showSnackBar('Por favor, insira um link.');
      return;
    }

    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    if (!url.contains('en.wikipedia.org/wiki/')) {
      _showSnackBar('Use um link da Wikipedia em Inglês (en.wikipedia.org).');
      return;
    }

    setState(() {
      _isLoading = true;
      _hasContent = false;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);

        final titleElement = document.querySelector('#firstHeading');

        final firstParagraphElement = document.querySelector(
          '#mw-content-text .mw-parser-output > p:not(.mw-empty-elt)',
        );

        String content = 'Conteúdo Principal Não Encontrado.';

        if (firstParagraphElement != null) {
          firstParagraphElement
              .querySelectorAll('sup')
              .forEach((e) => e.remove());

          firstParagraphElement
              .querySelectorAll(
                '.IPA, .reference, .rt-comment, .noprint, style, script, .mw-editsection',
              )
              .forEach((e) => e.remove());

          content = firstParagraphElement.text;

          content = content.replaceAll(RegExp(r'\[.*?\]'), '');

          content = content.replaceAll(
            RegExp(r'\s*\([^)]*[^\w\s,][^)]*\)'),
            '',
          );

          content = content.trim();
        }

        final String title = titleElement?.text ?? 'Título Não Encontrado';

        setState(() {
          _pageTitle = title.replaceAll('[edit]', '').trim();
          _pageContent = content;
          _hasContent = true;
        });
      } else {
        setState(() {
          _pageContent = 'Erro ao carregar a página: ${response.statusCode}';
          _pageTitle = 'Erro';
        });
      }
    } catch (e) {
      setState(() {
        _pageContent = 'Ocorreu um erro: $e';
        _pageTitle = 'Erro';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLearnedWord(String word, bool isLearned) async {
    if (isLearned) {
      await _dbHelper.removeWord(word);
    } else {
      await _dbHelper.addWord(word);
    }
    widget.onWordStatusChanged();
    _showSnackBar(
      isLearned ? 'Palavra removida: $word' : 'Palavra aprendida: $word',
    );
  }

  List<String> _getWordsFromContent() {
    final cleanText = _pageContent
        .replaceAll(RegExp(r'[.,;?!"()\[\]]'), '')
        .replaceAll(RegExp(r'[\s\n]+'), ' ');

    return cleanText.split(' ').where((w) {
      return w.isNotEmpty && w.length > 1 && !w.contains(RegExp(r'[0-9]'));
    }).toList();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: 'Palavras Aprendidas',
            onPressed: () => Navigator.pushNamed(
              context,
              '/learned',
            ).then((_) => widget.onWordStatusChanged()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'Link da Wikipedia (EN)',
                        hintText: 'ex: en.wikipedia.org/wiki/Flutter',
                        prefixIcon: Icon(Icons.link),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _fetchAndParseWikipedia,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.book),
                        label: const Text(
                          'Ler Agora',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (_hasContent || _isLoading)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Texto do Artigo:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _getWordsFromContent().map((word) {
                            final isLearned = widget.learnedWords.contains(
                              word.toLowerCase(),
                            );
                            return _buildWordWidget(word, isLearned, theme);
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    _pageContent,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordWidget(String word, bool isLearned, ThemeData theme) {
    final cleanWord = word.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();

    if (isLearned) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.withOpacity(0.5)),
        ),
        child: Text(
          word,
          style: TextStyle(
            color: Colors.green[800],
            decoration: TextDecoration.lineThrough,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ActionChip(
      label: Text(word),
      labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
      onPressed: () => _navigateToDefinition(cleanWord),
      backgroundColor: theme.colorScheme.primaryContainer,
      elevation: 1,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void _navigateToDefinition(String word) async {
    if (word.isEmpty) return;

    final bool? learned = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DefinitionPage(word: word)),
    );

    if (learned == true) {
      await _toggleLearnedWord(word, false);
    }
  }
}
