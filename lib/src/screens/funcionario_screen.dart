import 'package:flutter/material.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';
import '../services/treinamento_service.dart';
import '../models/treinamento_realizado.dart';

class FuncionarioScreen extends StatelessWidget {
  const FuncionarioScreen({super.key});

  // Retorna o ícone correto mapeado de acordo com o setor informado
  IconData _getIconeSetor(String setor) {
    switch (setor.trim().toLowerCase()) {
      case 'manutenção':
      case 'manutencao':
        return Icons.build;
      case 'produção':
      case 'producao':
        return Icons.factory;
      case 'almoxarifado':
        return Icons.inventory;
      default:
        return Icons.person; // Ícone padrão caso venha outro setor
    }
  }

  // Exercício 2: ao tocar num funcionário, consultar o histórico dele na API.
  void _mostrarTreinamentos(BuildContext context, Funcionario funcionario) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Treinamentos de ${funcionario.nome}'),
        content: SizedBox(
          width: 360,
          height: 300,
          child: FutureBuilder<List<TreinamentoRealizado>>(
            future: TreinamentoService().buscarRealizados(funcionario.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }
              final realizados = snapshot.data ?? [];
              if (realizados.isEmpty) {
                return const Text('Nenhum treinamento concluído.');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: realizados.length,
                itemBuilder: (context, index) {
                  final registro = realizados[index];
                  return ListTile(
                    leading: Icon(
                      registro.vencido ? Icons.warning_amber : Icons.check_circle,
                      color: registro.vencido ? Colors.orange : Colors.green,
                    ),
                    title: Text(registro.treinamento.titulo),
                    subtitle: Text(registro.vencido
                        ? 'Concluído em ${registro.dataFormatada} - Vencido – refazer'
                        : 'Concluído em ${registro.dataFormatada}'),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Funcionários'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Funcionario>>(
        future: FuncionarioService().buscarFuncionarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }
          
          final funcionarios = snapshot.data ?? [];
          
          if (funcionarios.isEmpty) {
            return const Center(child: Text('Nenhum funcionário encontrado.'));
          }

          return ListView.builder(
            itemCount: funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = funcionarios[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  onTap: () => _mostrarTreinamentos(context, funcionario),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      _getIconeSetor(funcionario.setor),
                      color: Colors.blue.shade800,
                    ),
                  ),
                  title: Text(
                    funcionario.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Setor: ${funcionario.setor}\nMatrícula: ${funcionario.matricula}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
