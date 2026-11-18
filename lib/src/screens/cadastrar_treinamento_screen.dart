import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/treinamento_service.dart';

class CadastrarTreinamentoScreen extends StatefulWidget {
  final Usuario usuario;

  const CadastrarTreinamentoScreen({super.key, required this.usuario});

  @override
  State<CadastrarTreinamentoScreen> createState() => _CadastrarTreinamentoScreenState();
}

class _CadastrarTreinamentoScreenState extends State<CadastrarTreinamentoScreen> {
  final formulario = GlobalKey<FormState>();
  final titulo = TextEditingController();
  final descricao = TextEditingController();
  final arquivo = TextEditingController();
  final validade = TextEditingController();
  bool enviando = false;

  @override
  void dispose() {
    titulo.dispose();
    descricao.dispose();
    arquivo.dispose();
    validade.dispose();
    super.dispose();
  }

  Future<void> cadastrar() async {
    if (!formulario.currentState!.validate()) return;
    setState(() => enviando = true);
    final nomeArquivo = arquivo.text.trim();
    final caminho = nomeArquivo.isEmpty
        ? null
        : '/arquivos/${nomeArquivo.split('/').last}';
    try {
      await TreinamentoService().cadastrar(
        adminId: widget.usuario.id,
        titulo: titulo.text.trim(),
        descricao: descricao.text.trim().isEmpty ? null : descricao.text.trim(),
        arquivoUrl: caminho,
        validadeMeses: validade.text.trim().isEmpty ? null : int.parse(validade.text.trim()),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treinamento cadastrado'), backgroundColor: Colors.green),
      );
      formulario.currentState!.reset();
      titulo.clear();
      descricao.clear();
      arquivo.clear();
      validade.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Treinamento'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formulario,
          child: Column(
            children: [
              TextFormField(
                controller: titulo,
                decoration: const InputDecoration(labelText: 'Título *', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe o título do treinamento'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricao,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: arquivo,
                decoration: const InputDecoration(
                  labelText: 'Nome do arquivo PDF',
                  hintText: 'nr06.pdf',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: validade,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Validade em meses (opcional)',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) return null;
                  final meses = int.tryParse(valor.trim());
                  return meses != null && meses > 0 ? null : 'Informe um número maior que zero';
                },
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: enviando ? null : cadastrar,
                child: enviando
                    ? const CircularProgressIndicator()
                    : const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
