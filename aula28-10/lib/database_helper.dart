import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('calculator.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Cria as tabelas 'dados' e 'operacoes'
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE dados (
      id INTEGER PRIMARY KEY,
      displayValue TEXT,
      memoryValue REAL
    )
    ''');
    
    await db.execute('''
    CREATE TABLE operacoes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      operationString TEXT,
      timestamp TEXT
    )
    ''');

    // Insere o estado inicial na tabela 'dados'
    // Usaremos sempre a linha com id = 1 para salvar o estado
    await db.insert('dados', {'id': 1, 'displayValue': '0', 'memoryValue': 0.0});
  }

  // Carrega o último estado salvo (display e memória)
  Future<Map<String, dynamic>> loadState() async {
    final db = await instance.database;
    final result = await db.query('dados', where: 'id = ?', whereArgs: [1]);
    return result.first;
  }

  // Salva o estado atual (display e memória) na tabela 'dados'
  Future<void> saveState(String display, double memory) async {
    final db = await instance.database;
    await db.update(
      'dados',
      {'displayValue': display, 'memoryValue': memory},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // Salva uma string de operação na tabela 'operacoes'
  Future<void> saveOperation(String operation) async {
    final db = await instance.database;
    await db.insert('operacoes', {
      'operationString': operation,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Recupera todas as operações salvas, da mais recente para a mais antiga
  Future<List<Map<String, dynamic>>> getOperations() async {
    final db = await instance.database;
    return await db.query('operacoes', orderBy: 'id DESC');
  }
}