import 'epi.dart';

class Emprestimo {
  final int id;
  final DateTime dataEmprestimo;
  final String status;
  final String observacao;
  final Epi epi;

  const Emprestimo({
    required this.id,
    required this.dataEmprestimo,
    required this.status,
    required this.observacao,
    required this.epi,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      id: (json['id'] as num).toInt(),
      dataEmprestimo: DateTime.parse(json['dataEmprestimo'] as String),
      status: json['status'] as String? ?? '',
      observacao: json['observacao'] as String? ?? '',
      epi: Epi.fromJson(json['epi'] as Map<String, dynamic>),
    );
  }
}
