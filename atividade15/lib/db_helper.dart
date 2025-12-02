import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'wikireader.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE LearnedWords (
        word TEXT PRIMARY KEY
      )
    ''');
  }

  Future<void> addWord(String word) async {
    final db = await database;
    await db.insert(
      'LearnedWords',
      {'word': word.toLowerCase()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeWord(String word) async {
    final db = await database;
    await db.delete(
      'LearnedWords',
      where: 'word = ?',
      whereArgs: [word.toLowerCase()],
    );
  }

  Future<List<String>> getLearnedWords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('LearnedWords');
    return List.generate(maps.length, (i) {
      return maps[i]['word'] as String;
    });
  }
}