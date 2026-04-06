import 'package:flutter/material.dart';
import 'modelos_e_sessao.dart';
import 'telas_perfil.dart';
import 'tela_formulario.dart';
import 'telas_chat.dart';

ImageProvider getImage(String path) {
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  } else {
    return NetworkImage(path);
  }
}

class TelaFeed extends StatefulWidget {
  const TelaFeed({super.key});

  @override
  State<TelaFeed> createState() => _TelaFeedState();
}

class _TelaFeedState extends State<TelaFeed> {
  final TextEditingController _buscaCtrl = TextEditingController();
  String termoBusca = '';

  @override
  Widget build(BuildContext context) {
    final jogadoresFiltrados = bancoDeJogadores.where((j) {
      return j.nome.toLowerCase().contains(termoBusca.toLowerCase()) ||
          j.posicao.toLowerCase().contains(termoBusca.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Descobrir Talentos"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          SessaoApp.isOlheiro
                              ? "Encontre jogadores, favorite perfis e envie contato direto."
                              : "Veja talentos em destaque no Fut Talentos.",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      if (SessaoApp.isOlheiro)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "❤ ${FavoritosStore.totalFavoritos}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _buscaCtrl,
                  decoration: const InputDecoration(
                    hintText: "Buscar por nome ou posição...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      termoBusca = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: jogadoresFiltrados.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhum talento encontrado.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: jogadoresFiltrados.length,
                    itemBuilder: (context, index) {
                      final j = jogadoresFiltrados[index];
                      final isFavorito = FavoritosStore.isFavorito(j.id);

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 350 + (index * 80)),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(22),
                                      ),
                                      image: DecorationImage(
                                        image: j.fotoCapaUrl.isNotEmpty
                                            ? getImage(j.fotoCapaUrl)
                                            : getImage(j.fotoUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(22),
                                        ),
                                        gradient: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ).gradient,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                        children: [
                                          Hero(
                                            tag: 'avatar_${j.id}',
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              backgroundImage:
                                                  j.fotoUrl.isNotEmpty
                                                      ? getImage(j.fotoUrl)
                                                      : null,
                                              child: j.fotoUrl.isEmpty
                                                  ? Text(
                                                      j.nome[0],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  j.nome,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  "${j.posicao} • ${j.idade} anos",
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (SessaoApp.isOlheiro)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.black.withOpacity(0.45),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              FavoritosStore.alternarFavorito(
                                                j.id,
                                              );
                                            });

                                            final agoraEhFavorito =
                                                FavoritosStore.isFavorito(j.id);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  agoraEhFavorito
                                                      ? "${j.nome} adicionado aos favoritos."
                                                      : "${j.nome} removido dos favoritos.",
                                                ),
                                                backgroundColor: agoraEhFavorito
                                                    ? Colors.green
                                                    : Colors.redAccent,
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            isFavorito
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorito
                                                ? Colors.redAccent
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        _infoChip(
                                          context,
                                          Icons.bar_chart,
                                          "OVR ${j.overall}",
                                        ),
                                        _infoChip(
                                          context,
                                          Icons.sports_soccer,
                                          "${j.gols} gols",
                                        ),
                                        _infoChip(
                                          context,
                                          Icons.assistant,
                                          "${j.assistencias} assist.",
                                        ),
                                        _infoChip(
                                          context,
                                          Icons.directions_run,
                                          j.peBom,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      j.descricao,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      TelaPerfilAtleta(
                                                    jogador: j,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.visibility),
                                            label: const Text("Ver perfil"),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        if (SessaoApp.isOlheiro)
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                const mensagemInicial =
                                                    "Olá,Vi seu perfil e gostaria de conversar sobre uma oportunidade.";

                                                ChatStore
                                                    .enviarMensagemParaJogador(
                                                  jogador: j,
                                                  texto: mensagemInicial,
                                                );

                                                final conversa = ChatStore
                                                    .obterOuCriarConversaComJogador(
                                                  j,
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Mensagem enviada para ${j.nome}!",
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        TelaChatDetalhe(
                                                      conversa: conversa,
                                                    ),
                                                  ),
                                                ).then((_) => setState(() {}));
                                              },
                                              icon: const Icon(Icons.message),
                                              label: const Text("Mensagem"),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<TelaBusca> createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  String termoBusca = '';
  String filtroPosicao = 'Todos';
  final TextEditingController _idadeMinCtrl = TextEditingController();
  final TextEditingController _idadeMaxCtrl = TextEditingController();
  final TextEditingController _overallMinCtrl = TextEditingController();
  bool somenteFavoritos = false;

  @override
  void dispose() {
    _idadeMinCtrl.dispose();
    _idadeMaxCtrl.dispose();
    _overallMinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idadeMin = int.tryParse(_idadeMinCtrl.text);
    final idadeMax = int.tryParse(_idadeMaxCtrl.text);
    final overallMin = int.tryParse(_overallMinCtrl.text);

    final jogadoresFiltrados = bancoDeJogadores.where((j) {
      final combinaNome = termoBusca.isEmpty ||
          j.nome.toLowerCase().contains(termoBusca.toLowerCase()) ||
          j.posicao.toLowerCase().contains(termoBusca.toLowerCase());

      final combinaPosicao = filtroPosicao == 'Todos' ||
          j.posicao.toLowerCase().contains(filtroPosicao.toLowerCase());

      final combinaIdadeMin = idadeMin == null || j.idade >= idadeMin;
      final combinaIdadeMax = idadeMax == null || j.idade <= idadeMax;
      final combinaOverall = overallMin == null || j.overall >= overallMin;

      final combinaFavoritos = !somenteFavoritos ||
          (SessaoApp.isOlheiro && FavoritosStore.isFavorito(j.id));

      return combinaNome &&
          combinaPosicao &&
          combinaIdadeMin &&
          combinaIdadeMax &&
          combinaOverall &&
          combinaFavoritos;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Talentos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Nome do jogador ou posição...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  termoBusca = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idadeMinCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Idade mín.",
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _idadeMaxCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Idade máx.",
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _overallMinCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Overall mínimo",
                prefixIcon: Icon(Icons.bar_chart),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Filtrar por Posição:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildFiltroChip("Todos"),
                _buildFiltroChip("Goleiro"),
                _buildFiltroChip("Zagueiro"),
                _buildFiltroChip("Meio"),
                _buildFiltroChip("Atacante"),
                if (SessaoApp.isOlheiro)
                  FilterChip(
                    label: const Text("Só favoritos"),
                    selected: somenteFavoritos,
                    onSelected: (value) {
                      setState(() {
                        somenteFavoritos = value;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Resultados: ${jogadoresFiltrados.length}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: jogadoresFiltrados.isEmpty
                  ? const Center(
                      child: Text("Nenhum jogador encontrado."),
                    )
                  : ListView.builder(
                      itemCount: jogadoresFiltrados.length,
                      itemBuilder: (context, index) {
                        final j = jogadoresFiltrados[index];
                        final isFavorito = FavoritosStore.isFavorito(j.id);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundImage: j.fotoUrl.isNotEmpty
                                  ? getImage(j.fotoUrl)
                                  : null,
                              child: j.fotoUrl.isEmpty
                                  ? Text(
                                      j.nome[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Row(
                              children: [
                                Expanded(child: Text(j.nome)),
                                if (SessaoApp.isOlheiro)
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        FavoritosStore.alternarFavorito(j.id);
                                      });
                                    },
                                    icon: Icon(
                                      isFavorito
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorito
                                          ? Colors.redAccent
                                          : Colors.white54,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Text(
                              "${j.posicao} • ${j.idade} anos • OVR ${j.overall}",
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TelaPerfilAtleta(jogador: j),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltroChip(String valor) {
    return FilterChip(
      label: Text(valor),
      selected: filtroPosicao == valor,
      onSelected: (_) {
        setState(() {
          filtroPosicao = valor;
        });
      },
    );
  }
}

class TelaGerenciarElenco extends StatefulWidget {
  const TelaGerenciarElenco({super.key});

  @override
  State<TelaGerenciarElenco> createState() => _TelaGerenciarElencoState();
}

class _TelaGerenciarElencoState extends State<TelaGerenciarElenco> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel do Olheiro")),
      body: ListView.builder(
        itemCount: bancoDeJogadores.length,
        itemBuilder: (context, index) {
          final j = bancoDeJogadores[index];
          final isFavorito = FavoritosStore.isFavorito(j.id);

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: j.fotoUrl.isNotEmpty ? getImage(j.fotoUrl) : null,
              child: j.fotoUrl.isEmpty ? Text(j.nome[0]) : null,
            ),
            title: Text(j.nome),
            subtitle: Text(j.posicao),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFavorito ? Icons.favorite : Icons.favorite_border,
                  color: isFavorito ? Colors.redAccent : Colors.white38,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TelaFormularioJogador(jogadorParaEditar: j),
                    ),
                  ).then((_) => setState(() {})),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TelaFormularioJogador(),
          ),
        ).then((_) => setState(() {})),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}