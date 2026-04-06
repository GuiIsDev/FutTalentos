import 'package:flutter/material.dart';
import 'modelos_e_sessao.dart';
import 'tela_dashboard.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF060D08), Color(0xFF0D5C2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                const Column(
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      size: 100,
                      color: Color(0xFF1FAA59),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Fut Talentos',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sua chance no mundo do futebol começa aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TelaAuth(isRegistro: true),
                          ),
                        ),
                        child: const Text('Criar Conta'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TelaAuth(isRegistro: false),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF1FAA59),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1FAA59),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TelaAuth extends StatefulWidget {
  final bool isRegistro;
  const TelaAuth({super.key, required this.isRegistro});
  @override
  State<TelaAuth> createState() => _TelaAuthState();
}

class _TelaAuthState extends State<TelaAuth> {
  bool _isOlheiro = false;
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _nomeCtrl = TextEditingController();
  final _sobrenomeCtrl = TextEditingController();
  final _clubeCtrl = TextEditingController();

  void _validarEAvancar() {
    String email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Obrigatório usar um e-mail @gmail.com válido"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_senhaCtrl.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A senha deve ter pelo menos 4 caracteres."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    SessaoApp.isOlheiro = _isOlheiro;

    if (widget.isRegistro) {
      SessaoApp.nomeCompleto = "${_nomeCtrl.text} ${_sobrenomeCtrl.text}";
      SessaoApp.clube = _isOlheiro ? _clubeCtrl.text : "";
      if (!_isOlheiro) {
        SessaoApp.meuPerfilJogador = Jogador(
          id: DateTime.now().toString(),
          nome: SessaoApp.nomeCompleto,
          posicao: "Defina sua posição",
          idade: 18,
          overall: 50,
        );
        bancoDeJogadores.add(SessaoApp.meuPerfilJogador!);
      }
    } else {
      SessaoApp.nomeCompleto = "Usuário Logado";
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaDashboard()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isRegistro ? "Crie sua conta" : "Bem-vindo",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            if (widget.isRegistro) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nomeCtrl,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _sobrenomeCtrl,
                      decoration: const InputDecoration(labelText: 'Sobrenome'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Eu sou um:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text(
                        "Jogador",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: false,
                      groupValue: _isOlheiro,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (v) => setState(() => _isOlheiro = v as bool),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text(
                        "Olheiro",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: true,
                      groupValue: _isOlheiro,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (v) => setState(() => _isOlheiro = v as bool),
                    ),
                  ),
                ],
              ),
              if (_isOlheiro) ...[
                TextField(
                  controller: _clubeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Clube / Agência',
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ],
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail (@gmail.com)',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _senhaCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _validarEAvancar,
              child: Text(widget.isRegistro ? "Finalizar Registro" : "Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
