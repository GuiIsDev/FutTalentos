import 'package:flutter/material.dart';
import 'modelos_e_sessao.dart';

ImageProvider getImage(String path) {
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  } else {
    return NetworkImage(path);
  }
}

class TelaChat extends StatefulWidget {
  const TelaChat({super.key});

  @override
  State<TelaChat> createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mensagens")),
      body: ChatStore.conversas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma conversa iniciada ainda.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: ChatStore.conversas.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final conversa = ChatStore.conversas[index];
                final ultima = conversa.ultimaMensagem;

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: conversa.fotoContato.isNotEmpty
                          ? getImage(conversa.fotoContato)
                          : null,
                      child: conversa.fotoContato.isEmpty
                          ? Text(
                              conversa.nomeContato[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      conversa.nomeContato,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ultima?.texto ?? "Sem mensagens ainda.",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TelaChatDetalhe(conversa: conversa),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}

class TelaChatDetalhe extends StatefulWidget {
  final ConversaChat conversa;
  const TelaChatDetalhe({super.key, required this.conversa});

  @override
  State<TelaChatDetalhe> createState() => _TelaChatDetalheState();
}

class _TelaChatDetalheState extends State<TelaChatDetalhe> {
  final TextEditingController _msgCtrl = TextEditingController();

  void _enviarMensagem() {
    if (_msgCtrl.text.trim().isEmpty) return;

    ChatStore.enviarMensagemNaConversa(
      conversa: widget.conversa,
      texto: _msgCtrl.text.trim(),
      enviadaPorMim: true,
    );

    _msgCtrl.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mensagens = widget.conversa.mensagens;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversa.nomeContato),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: mensagens.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhuma mensagem ainda.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      final msg = mensagens[index];

                      return Align(
                        alignment: msg.enviadaPorMim
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: msg.enviadaPorMim
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[850],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(
                                msg.enviadaPorMim ? 16 : 0,
                              ),
                              bottomRight: Radius.circular(
                                msg.enviadaPorMim ? 0 : 16,
                              ),
                            ),
                          ),
                          child: Text(
                            msg.texto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(
              8,
            ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(hintText: "Mensagem..."),
                    onSubmitted: (_) => _enviarMensagem(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _enviarMensagem,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
