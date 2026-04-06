import 'package:flutter/material.dart';
import 'modelos_e_sessao.dart';

class TelaFormularioJogador extends StatefulWidget {
  final Jogador? jogadorParaEditar;
  const TelaFormularioJogador({super.key, this.jogadorParaEditar});

  @override
  State<TelaFormularioJogador> createState() => _TelaFormularioJogadorState();
}

class _TelaFormularioJogadorState extends State<TelaFormularioJogador> {
  final _nomeCtrl = TextEditingController();
  final _posicaoCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  final _overallCtrl = TextEditingController();
  final _golsCtrl = TextEditingController();
  final _fotoCtrl = TextEditingController();
  final _fotoCapaCtrl = TextEditingController(); // Novo controlador para a capa
  final _descCtrl = TextEditingController();
  final _clubesCtrl = TextEditingController();
  String _peBom = "Direito";

  @override
  void initState() {
    super.initState();
    if (widget.jogadorParaEditar != null) {
      _nomeCtrl.text = widget.jogadorParaEditar!.nome;
      _posicaoCtrl.text = widget.jogadorParaEditar!.posicao;
      _idadeCtrl.text = widget.jogadorParaEditar!.idade.toString();
      _overallCtrl.text = widget.jogadorParaEditar!.overall.toString();
      _golsCtrl.text = widget.jogadorParaEditar!.gols.toString();
      _fotoCtrl.text = widget.jogadorParaEditar!.fotoUrl;
      _fotoCapaCtrl.text = widget.jogadorParaEditar!.fotoCapaUrl;
      _descCtrl.text = widget.jogadorParaEditar!.descricao;
      _clubesCtrl.text = widget.jogadorParaEditar!.clubesAnteriores;
      _peBom = widget.jogadorParaEditar!.peBom;
    }
  }

  void _salvar() {
    if (_nomeCtrl.text.isEmpty) return;

    if (widget.jogadorParaEditar == null) {
      bancoDeJogadores.add(
        Jogador(
          id: DateTime.now().toString(),
          nome: _nomeCtrl.text,
          posicao: _posicaoCtrl.text,
          idade: int.tryParse(_idadeCtrl.text) ?? 18,
          overall: int.tryParse(_overallCtrl.text) ?? 50,
          gols: int.tryParse(_golsCtrl.text) ?? 0,
          fotoUrl: _fotoCtrl.text,
          fotoCapaUrl: _fotoCapaCtrl.text,
          descricao: _descCtrl.text,
          clubesAnteriores: _clubesCtrl.text,
          peBom: _peBom,
        ),
      );
    } else {
      widget.jogadorParaEditar!.nome = _nomeCtrl.text;
      widget.jogadorParaEditar!.posicao = _posicaoCtrl.text;
      widget.jogadorParaEditar!.idade = int.tryParse(_idadeCtrl.text) ?? 18;
      widget.jogadorParaEditar!.overall = int.tryParse(_overallCtrl.text) ?? 50;
      widget.jogadorParaEditar!.gols = int.tryParse(_golsCtrl.text) ?? 0;
      widget.jogadorParaEditar!.fotoUrl = _fotoCtrl.text;
      widget.jogadorParaEditar!.fotoCapaUrl = _fotoCapaCtrl.text;
      widget.jogadorParaEditar!.descricao = _descCtrl.text;
      widget.jogadorParaEditar!.clubesAnteriores = _clubesCtrl.text;
      widget.jogadorParaEditar!.peBom = _peBom;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Perfil salvo com sucesso"),
        backgroundColor: Colors.green,
      ),
    );
    if (SessaoApp.isOlheiro || widget.jogadorParaEditar != null) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _posicaoCtrl.dispose();
    _idadeCtrl.dispose();
    _overallCtrl.dispose();
    _golsCtrl.dispose();
    _fotoCtrl.dispose();
    _fotoCapaCtrl.dispose();
    _descCtrl.dispose();
    _clubesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.jogadorParaEditar != null
              ? "Editar Perfil"
              : "Adicionar Jogador",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome / Apelido"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fotoCtrl,
              decoration: const InputDecoration(
                labelText: "URL da Foto de Perfil",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fotoCapaCtrl,
              decoration: const InputDecoration(
                labelText: "URL da Foto de Capa",
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _posicaoCtrl,
                    decoration: const InputDecoration(labelText: "Posição"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _idadeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Idade"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _golsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Gols"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _peBom,
                    decoration: const InputDecoration(labelText: "Pé Bom"),
                    items: ["Direito", "Esquerdo", "Ambidestro"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _peBom = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _clubesCtrl,
              decoration: const InputDecoration(labelText: "Clubes Anteriores"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Biografia / Descrição",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text("Salvar Dados"),
            ),
          ],
        ),
      ),
    );
  }
}
