import 'package:flutter/material.dart';
import 'epi_screen.dart';
import 'funcionario_screen.dart';
import '../models/usuario.dart';
import 'login_screen.dart';
import 'meus_emprestimos_screen.dart';
import 'treinamentos_screen.dart';
import 'cadastrar_treinamento_screen.dart';

class MainScreen extends StatelessWidget {
  final Usuario usuario;
  const MainScreen({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empréstimos de EPIs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(usuario.nome),
              accountEmail: Text(usuario.perfil),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  usuario.nome[0],
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('EPIs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  // CORREÇÃO AQUI: Removido o 'const' e adicionado 'usuario: usuario'
                  MaterialPageRoute(builder: (_) => EpiScreen(usuario: usuario)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: const Text('Meus Empréstimos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MeusEmprestimosScreen(usuario: usuario),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Funcionários'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FuncionarioScreen()),
                );
              },
            ),
            // Aula 6: treinamentos disponíveis para todos os perfis.
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Treinamentos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TreinamentosScreen(usuario: usuario)),
                );
              },
            ),
            if (usuario.perfil == 'ADMIN')
              ListTile(
                leading: const Icon(Icons.add_box_outlined),
                title: const Text('Cadastrar Treinamento'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CadastrarTreinamentoScreen(usuario: usuario),
                    ),
                  );
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Bem-vindo ${usuario.nome}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
