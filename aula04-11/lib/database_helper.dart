// lib/database_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tarefa_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tarefas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Cria a tabela "tarefas" quando o DB é criado pela primeira vez
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        isDone INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // --- Funções CRUD (Create, Read, Update, Delete) ---

  // 1. Criar tarefa
  Future<int> createTarefa(Tarefa tarefa) async {
    final db = await database;
    // Usamos 'insert' que é mais limpo que 'rawInsert' e protege contra SQL injection
    return await db.insert('tarefas', tarefa.toMap());
  }

  // 2. Atualizar tarefa (usado para alterar texto e marcar como feita)
  Future<int> updateTarefa(Tarefa tarefa) async {
    final db = await database;
    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  // 3. Deletar tarefa (Bônus, não pedido, mas essencial)
  Future<int> deleteTarefa(int id) async {
    final db = await database;
    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 4. Visualizar todas as tarefas
  Future<List<Tarefa>> getAllTarefas() async {
    final db = await database;
    // 'query' é mais limpo que 'rawQuery'
    final List<Map<String, dynamic>> maps = await db.query('tarefas', orderBy: 'date');
    
    return List.generate(maps.length, (i) {
      return Tarefa.fromMap(maps[i]);
    });
  }

  // 5. Visualizar tarefa por data
  Future<List<Tarefa>> getTarefasByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tarefas',
      where: 'date = ?',
      whereArgs: [date],
    );

    return List.generate(maps.length, (i) {
      return Tarefa.fromMap(maps[i]);
    });
  }
}