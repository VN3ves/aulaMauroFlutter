// lib/tarefa_model.dart

class Tarefa {
  int? id;
  String title;
  bool isDone;
  String date; // Armazena a data como texto no formato 'yyyy-MM-dd'

  Tarefa({
    this.id,
    required this.title,
    required this.date,
    this.isDone = false,
  });

  // Converte um objeto Tarefa em um Map.
  // Usado ao inserir/atualizar no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isDone': isDone ? 1 : 0, // SQLite não tem boolean, usamos 1 (true) ou 0 (false)
    };
  }

  // Converte um Map (do banco de dados) em um objeto Tarefa.
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      isDone: map['isDone'] == 1,
    );
  }
}