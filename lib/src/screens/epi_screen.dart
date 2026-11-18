import 'package:flutter/material.dart';
import '../models/epi.dart';
import '../models/usuario.dart'; // Aula 4
import '../services/api_config.dart';
import '../services/epi_service.dart';
import 'epi_detalhe_screen.dart'; // Aula 4

class EpiScreen extends StatelessWidget {
  final Usuario usuario; // Aula 4: recebe o usuário logado

  const EpiScreen({
    super.key,
    required this.usuario, // Aula 4
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de EPIs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fechar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Epi>>(
        future: EpiService().buscarEpis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          
          final epis = snapshot.data ?? [];

          return ListView.builder(
            itemCount: epis.length,
            itemBuilder: (context, index) {
              final epi = epis[index];
              final urlImagem = '${ApiConfig.baseUrl}${epi.imagemUrl}';
              final bool isVencido = epi.caVencido;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: isVencido
                    ? RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: ListTile(
                  // Aula 4: ao tocar no EPI, abre a tela de detalhes
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EpiDetalheScreen(
                          epi: epi,
                          usuario: usuario,
                        ),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      urlImagem,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 55,
                          height: 55,
                          color: isVencido ? Colors.red.shade50 : Colors.blue.shade50,
                          child: Icon(
                            Icons.health_and_safety,
                            color: isVencido ? Colors.red : Colors.blue,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    epi.nome,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isVencido ? Colors.red.shade900 : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${epi.categoria}\nCA: ${epi.ca}${isVencido ? " (VENCIDO)" : ""}\nQtd Disponível: ${epi.quantidade}',
                    style: TextStyle(
                      color: isVencido ? Colors.red.shade700 : Colors.black54,
                    ),
                  ),
                  trailing: isVencido
                      ? const Icon(Icons.error_outline, color: Colors.red, size: 28)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
