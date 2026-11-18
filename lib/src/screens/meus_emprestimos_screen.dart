import 'package:flutter/material.dart';
import '../models/emprestimo.dart';
import '../models/usuario.dart';
import '../services/emprestimo_service.dart';

class MeusEmprestimosScreen extends StatefulWidget {
  final Usuario usuario;

  const MeusEmprestimosScreen({super.key, required this.usuario});

  @override
  State<MeusEmprestimosScreen> createState() => _MeusEmprestimosScreenState();
}

class _MeusEmprestimosScreenState extends State<MeusEmprestimosScreen> {
  late Future<List<Emprestimo>> _emprestimos;

  @override
  void initState() {
    super.initState();
    _atualizar();
  }

  void _atualizar() {
    _emprestimos = EmprestimoService().buscarPorFuncionario(widget.usuario.id);
  }

  Future<void> _recarregar() async {
    setState(_atualizar);
    try {
      await _emprestimos;
    } catch (_) {
      // O FutureBuilder apresenta a mensagem de erro.
    }
  }

  Color _corStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SOLICITADO':
        return Colors.orange.shade800;
      case 'EMPRESTADO':
        return Colors.green.shade700;
      case 'DEVOLVIDO':
        return Colors.grey.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Empréstimos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _recarregar,
          ),
        ],
      ),
      body: FutureBuilder<List<Emprestimo>>(
        future: _emprestimos,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    const Text('Não foi possível carregar os empréstimos.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _recarregar,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }
          final emprestimos = snapshot.data ?? [];
          if (emprestimos.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recarregar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Center(child: Text('Você ainda não possui empréstimos.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recarregar,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: emprestimos.length,
              itemBuilder: (context, index) {
                final emprestimo = emprestimos[index];
                final cor = _corStatus(emprestimo.status);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.health_and_safety_outlined,
                                color: Colors.blue, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(emprestimo.epi.nome,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: cor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(emprestimo.status,
                                  style: TextStyle(
                                      color: cor, fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text('Data da solicitação: ${_formatarData(emprestimo.dataEmprestimo)}'),
                        const SizedBox(height: 6),
                        Text('Motivo: ${emprestimo.observacao.isEmpty ? "Não informado" : emprestimo.observacao}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
