import 'package:flutter/material.dart';
import 'modelos_e_sessao.dart';
import 'tela_formulario.dart';
import 'telas_auth.dart';

ImageProvider getImage(String path) {
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  } else {
    return NetworkImage(path);
  }
}

class TelaPerfilAtleta extends StatelessWidget {
  final Jogador jogador;
  const TelaPerfilAtleta({super.key, required this.jogador});

  @override
  Widget build(BuildContext context) {
    bool isMeuPerfil =
        (!SessaoApp.isOlheiro && SessaoApp.meuPerfilJogador?.id == jogador.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    image: jogador.fotoCapaUrl.isNotEmpty
                        ? DecorationImage(
                            image: getImage(jogador.fotoCapaUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Hero(
                    tag: 'avatar_${jogador.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: jogador.fotoUrl.isNotEmpty
                            ? getImage(jogador.fotoUrl)
                            : null,
                        child: jogador.fotoUrl.isEmpty
                            ? Text(
                                jogador.nome[0],
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text(
              jogador.nome,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              "${jogador.posicao} | ${jogador.idade} anos",
              style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(context, "OVR", jogador.overall.toString()),
                    _buildStat(context, "Gols", jogador.gols.toString()),
                    _buildStat(
                      context,
                      "Assist",
                      jogador.assistencias.toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Biografia",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    jogador.descricao,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const Divider(height: 40),
                  ListTile(
                    leading: const Icon(
                      Icons.sports_soccer,
                      color: Colors.greenAccent,
                    ),
                    title: const Text("Pé Preferido"),
                    trailing: Text(
                      jogador.peBom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shield, color: Colors.blueAccent),
                    title: const Text("Clubes Anteriores"),
                    subtitle: Text(jogador.clubesAnteriores),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isMeuPerfil) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaFormularioJogador(
                                jogadorParaEditar: jogador,
                              ),
                            ),
                          );
                        } else if (SessaoApp.isOlheiro) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Proposta enviada para ${jogador.nome}!",
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      icon: Icon(isMeuPerfil ? Icons.edit : Icons.handshake),
                      label: Text(
                        isMeuPerfil ? "Editar Meu Perfil" : "Fazer Proposta",
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMeuPerfil
                            ? Colors.blueAccent
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String titulo, String valor) {
    return Column(
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(titulo, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

class TelaPerfilUsuario extends StatelessWidget {
  const TelaPerfilUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF1FAA59),
              backgroundImage: (!SessaoApp.isOlheiro &&
                      SessaoApp.meuPerfilJogador != null &&
                      SessaoApp.meuPerfilJogador!.fotoUrl.isNotEmpty)
                  ? getImage(SessaoApp.meuPerfilJogador!.fotoUrl)
                  : null,
              child: (SessaoApp.isOlheiro ||
                      SessaoApp.meuPerfilJogador == null ||
                      SessaoApp.meuPerfilJogador!.fotoUrl.isEmpty)
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              SessaoApp.nomeCompleto,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              SessaoApp.isOlheiro
                  ? "Perfil: Olheiro - ${SessaoApp.clube}"
                  : "Perfil: Jogador",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Sair da Conta",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TelaInicial()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}