import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/treinamento.dart';
import '../models/treinamento_realizado.dart';
import 'api_config.dart';

class TreinamentoService {
  // GET /treinamentos
  Future<List<Treinamento>> buscarTreinamentos() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/treinamentos'));
    if (response.statusCode == 200) {
      final List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
      return lista.map((item) => Treinamento.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar treinamentos');
  }

  // GET /treinamentos/realizados/funcionario/{id}
  Future<List<TreinamentoRealizado>> buscarRealizados(int funcionarioId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/treinamentos/realizados/funcionario/$funcionarioId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
      return lista.map((item) => TreinamentoRealizado.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar treinamentos concluídos');
  }

  // POST /treinamentos/{id}/concluir?funcionarioId=...
  Future<void> concluir(int treinamentoId, int funcionarioId) async {
    final response = await http.post(Uri.parse(
      '${ApiConfig.baseUrl}/treinamentos/$treinamentoId/concluir?funcionarioId=$funcionarioId',
    ));
    if (response.statusCode == 201) return;
    throw Exception(utf8.decode(response.bodyBytes));
  }

  // Exercício: POST /treinamentos?adminId=...
  Future<void> cadastrar({
    required int adminId,
    required String titulo,
    String? descricao,
    String? arquivoUrl,
    int? validadeMeses,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/treinamentos?adminId=$adminId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': titulo,
        'descricao': descricao,
        'arquivoUrl': arquivoUrl,
        'validadeMeses': validadeMeses,
      }),
    );
    if (response.statusCode == 201) return;
    throw Exception(utf8.decode(response.bodyBytes));
  }
}
