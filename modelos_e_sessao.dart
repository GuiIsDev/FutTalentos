class Jogador {
  String id;
  String nome;
  String posicao;
  int idade;
  int overall;
  int gols;
  int assistencias;
  String fotoUrl;
  String fotoCapaUrl;
  String descricao;
  String peBom;
  String clubesAnteriores;

  Jogador({
    required this.id,
    required this.nome,
    required this.posicao,
    required this.idade,
    required this.overall,
    this.gols = 0,
    this.assistencias = 0,
    this.fotoUrl = "",
    this.fotoCapaUrl = "",
    this.descricao = "Em busca de uma nova oportunidade no futebol.",
    this.peBom = "Direito",
    this.clubesAnteriores = "Base local",
  });
}

class SessaoApp {
  static bool isOlheiro = false;
  static String nomeCompleto = "Visitante";
  static String clube = "";
  static Jogador? meuPerfilJogador;
}

class MensagemChat {
  String texto;
  bool enviadaPorMim;
  DateTime horario;

  MensagemChat({
    required this.texto,
    required this.enviadaPorMim,
    required this.horario,
  });
}

class ConversaChat {
  String idContato;
  String nomeContato;
  String fotoContato;
  List<MensagemChat> mensagens;

  ConversaChat({
    required this.idContato,
    required this.nomeContato,
    required this.fotoContato,
    required this.mensagens,
  });

  MensagemChat? get ultimaMensagem {
    if (mensagens.isEmpty) return null;
    return mensagens.last;
  }
}

class ChatStore {
  static final List<ConversaChat> conversas = [];

  static ConversaChat obterOuCriarConversaComJogador(Jogador jogador) {
    final existente = conversas.where((c) => c.idContato == jogador.id).toList();

    if (existente.isNotEmpty) return existente.first;

    final nova = ConversaChat(
      idContato: jogador.id,
      nomeContato: jogador.nome,
      fotoContato: jogador.fotoUrl,
      mensagens: [],
    );

    conversas.insert(0, nova);
    return nova;
  }

  static void enviarMensagemParaJogador({
    required Jogador jogador,
    required String texto,
  }) {
    final conversa = obterOuCriarConversaComJogador(jogador);

    conversa.mensagens.add(
      MensagemChat(
        texto: texto,
        enviadaPorMim: true,
        horario: DateTime.now(),
      ),
    );

    conversas.remove(conversa);
    conversas.insert(0, conversa);
  }

  static void enviarMensagemNaConversa({
    required ConversaChat conversa,
    required String texto,
    required bool enviadaPorMim,
  }) {
    conversa.mensagens.add(
      MensagemChat(
        texto: texto,
        enviadaPorMim: enviadaPorMim,
        horario: DateTime.now(),
      ),
    );

    conversas.remove(conversa);
    conversas.insert(0, conversa);
  }
}

class FavoritosStore {
  static final List<String> _idsFavoritos = [];

  static bool isFavorito(String jogadorId) {
    return _idsFavoritos.contains(jogadorId);
  }

  static void alternarFavorito(String jogadorId) {
    if (_idsFavoritos.contains(jogadorId)) {
      _idsFavoritos.remove(jogadorId);
    } else {
      _idsFavoritos.add(jogadorId);
    }
  }

  static List<Jogador> get jogadoresFavoritos {
    return bancoDeJogadores
        .where((jogador) => _idsFavoritos.contains(jogador.id))
        .toList();
  }

  static int get totalFavoritos => _idsFavoritos.length;
}

List<Jogador> bancoDeJogadores = [
  Jogador(
    id: '2',
    nome: 'Vinicius Jr',
    posicao: 'Ponta-esquerda',
    idade: 24,
    overall: 91,
    gols: 85,
    assistencias: 60,
    fotoUrl: 'assets/images/vinicius_jr.jpeg',
    fotoCapaUrl: 'assets/images/vinicius_jr.jpeg',
    descricao:
        'Jogo na Ponta esquerda, e sou um otimo jogador para armar jogadas rápidas.',
    peBom: 'Direito',
    clubesAnteriores: 'Flamengo, Real Madrid',
  ),
  Jogador(
    id: '3',
    nome: 'Raphinha',
    posicao: 'Ponta-direita',
    idade: 28,
    overall: 87,
    gols: 58,
    assistencias: 42,
    fotoUrl: 'assets/images/raphinha.jpeg',
    fotoCapaUrl: 'assets/images/raphinha.jpeg',
    descricao:
        'Gosto de jogar na intesidade e não me canso facilmente',
    peBom: 'Esquerdo',
    clubesAnteriores: 'Avai, Vitoria de Guimaraes, Sporting, Rennes, Leeds United, Barcelona',
  ),
  Jogador(
    id: '4',
    nome: 'Calleri',
    posicao: 'Centroavante',
    idade: 31,
    overall: 84,
    gols: 71,
    assistencias: 19,
    fotoUrl: 'assets/images/calleri.jpeg',
    fotoCapaUrl: 'assets/images/calleri.jpeg',
    descricao:
        'Centroavante com sede de vencer!',
    peBom: 'Direito',
    clubesAnteriores: 'All Boys, Boca Juniors, Sao Paulo',
  ),
  Jogador(
    id: '5',
    nome: 'Endrick',
    posicao: 'Atacante',
    idade: 18,
    overall: 86,
    gols: 34,
    assistencias: 12,
    fotoUrl: 'assets/images/endrick.jpeg',
    fotoCapaUrl: 'assets/images/endrick.jpeg',
    descricao:
        'Consigo lidar bem em momentos de tensão e armar jogadas para sair na vantagem.',
    peBom: 'Esquerdo',
    clubesAnteriores: 'Palmeiras, Real Madrid',
  ),
];