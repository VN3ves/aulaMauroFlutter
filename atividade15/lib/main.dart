import 'package:flutter/material.dart';
import 'package:aula04_11/db_helper.dart';
import 'package:aula04_11/palavras.dart';
import 'package:aula04_11/wiki.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const WikiReaderApp());
}

class WikiReaderApp extends StatelessWidget {
  const WikiReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WikiReader English',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.teal,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WikiReaderHomePage(),
        '/learned': (context) => const LearnedWordsPage(),
      },
    );
  }
}

class WikiReaderHomePage extends StatefulWidget {
  const WikiReaderHomePage({super.key});

  @override
  State<WikiReaderHomePage> createState() => _WikiReaderHomePageState();
}

class _WikiReaderHomePageState extends State<WikiReaderHomePage> {
  late Future<List<String>> _learnedWordsFuture;
  final DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    _loadLearnedWords();
  }

  void _loadLearnedWords() {
    setState(() {
      _learnedWordsFuture = _dbHelper.getLearnedWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _learnedWordsFuture,
      builder: (context, snapshot) {
        return WikiReaderPage(
          onWordStatusChanged: _loadLearnedWords,
          learnedWords: snapshot.data ?? [],
        );
      },
    );
  }
}