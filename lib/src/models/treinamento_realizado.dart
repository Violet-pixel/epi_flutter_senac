import 'treinamento.dart';

class TreinamentoRealizado {
  final int id;
  final Treinamento treinamento;
  final DateTime dataConclusao;

  TreinamentoRealizado({
    required this.id,
    required this.treinamento,
    required this.dataConclusao,
  });

  factory TreinamentoRealizado.fromJson(Map<String, dynamic> json) {
    return TreinamentoRealizado(
      id: json['id'],
      treinamento: Treinamento.fromJson(json['treinamento']),
      dataConclusao: DateTime.parse(json['dataConclusao']),
    );
  }

  String get dataFormatada {
    final dia = dataConclusao.day.toString().padLeft(2, '0');
    final mes = dataConclusao.month.toString().padLeft(2, '0');
    return '$dia/$mes/${dataConclusao.year}';
  }

  // Desafio extra: validade em meses corridos a partir da conclusão.
  bool get vencido {
    final meses = treinamento.validadeMeses;
    if (meses == null) return false;
    final mesDestino = DateTime(dataConclusao.year, dataConclusao.month + meses, 1);
    final ultimoDia = DateTime(mesDestino.year, mesDestino.month + 1, 0).day;
    final dia = dataConclusao.day > ultimoDia ? ultimoDia : dataConclusao.day;
    final vencimento = DateTime(mesDestino.year, mesDestino.month, dia);
    final hoje = DateTime.now();
    return vencimento.isBefore(DateTime(hoje.year, hoje.month, hoje.day));
  }
}
