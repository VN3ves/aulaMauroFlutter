void main() {
  DateTime hoje = DateTime.now();

  int ano = hoje.year;
  int mes = hoje.month;
  int diaAtual = hoje.day;

  print("| D | S | T | Q | Q | S | S |");

  DateTime primeiroDia = DateTime(ano, mes, 1);
  int inicioSemana = primeiroDia.weekday % 7; 

  String linha = "";
  for (int i = 0; i < inicioSemana; i++) {
    linha += "    ";
  }

  for (int dia = 1; dia <= diaAtual; dia++) {
    String diaStr = dia.toString().padLeft(2, ' ');

    linha += " $diaStr ";

    if ((inicioSemana + dia) % 7 == 0) {
      print(linha);
      linha = "";
    }
  }
  if (linha.isNotEmpty) {
    print(linha);
  }
}
