void main() {
  // Número do mês informado
  int informado = 10;

  // Obtendo o número do mês atual usando DateTime
  int atual = DateTime.now().month;

  // Comparação
  if (atual > informado) {
    print('$atual é maior que $informado');
  } else if (atual < informado) {
    print('$atual é menor que $informado');
  } else {
    print('$atual é igual a $informado');
  }
}
