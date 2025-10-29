import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Você pode precisar adicionar a dependência intl
import 'database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _operationsFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _operationsFuture = DatabaseHelper.instance.getOperations();
  }

  // Formata a data para exibição
  String _formatTimestamp(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      // Ex: 28/10/2025 23:50
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return isoDate; // Retorna a string original se houver erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Operações'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _operationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma operação registrada.'),
            );
          }

          final operations = snapshot.data!;

          return ListView.builder(
            itemCount: operations.length,
            itemBuilder: (context, index) {
              final op = operations[index];
              return ListTile(
                title: Text(
                  op['operationString'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_formatTimestamp(op['timestamp'])),
              );
            },
          );
        },
      ),
    );
  }
}