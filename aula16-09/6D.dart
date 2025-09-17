import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // Inicializa a formatação de data para o local 'pt_BR'
  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(const CalendarioApp());
  });
}

class CalendarioApp extends StatelessWidget {
  const CalendarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calendário do Mês',
      home: TelaCalendario(),
    );
  }
}

// --- TELA 1: Calendário ---
class TelaCalendario extends StatefulWidget {
  const TelaCalendario({super.key});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  late DateTime hoje;
  late int diasNoMes;
  late int primeiroDiaDaSemana;

  @override
  void initState() {
    super.initState();
    hoje = DateTime.now();
    diasNoMes = DateTime(hoje.year, hoje.month + 1, 0).day;
    primeiroDiaDaSemana = DateTime(hoje.year, hoje.month, 1).weekday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMM('pt_BR').format(hoje)), // Ex: setembro de 2025
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: diasNoMes + primeiroDiaDaSemana - 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (context, index) {
          if (index < primeiroDiaDaSemana - 1) {
            return Container(); // Espaços vazios no início do mês
          } else {
            final dia = index - primeiroDiaDaSemana + 2;
            final dataDoBotao = DateTime(hoje.year, hoje.month, dia);

            return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaDetalheDia(dataSelecionada: dataDoBotao),
                  ),
                );
              },
              child: Text(
                dia.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}

// --- TELA 2: Detalhe do Dia ---
class TelaDetalheDia extends StatelessWidget {
  final DateTime dataSelecionada;

  const TelaDetalheDia({super.key, required this.dataSelecionada});

  @override
  Widget build(BuildContext context) {
    // Formata a data para exibir "terça-feira, 16"
    final String textoFormatado = DateFormat('EEEE, d', 'pt_BR').format(dataSelecionada);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Data Selecionada')),
      body: Center(
        child: Text(
          'Você selecionou: $textoFormatado',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}