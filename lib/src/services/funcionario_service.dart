import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/funcionario.dart';

class FuncionarioService {
  // Alterado para http:// para evitar o bloqueio de segurança do HTTPS local
  final String baseUrl = 'http://localhost:8080/funcionarios';

  Future<List<Funcionario>> buscarFuncionarios() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> dados = json.decode(response.body);
        return dados.map((json) => Funcionario.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar funcionários do servidor');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
