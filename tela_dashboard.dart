import 'package:flutter/material.dart';
import 'modelos_e_sessao.dart';
import 'telas_principais.dart';
import 'telas_chat.dart';
import 'telas_perfil.dart';
import 'tela_formulario.dart';

class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const TelaFeed(),
      const TelaBusca(),
      SessaoApp.isOlheiro
          ? const TelaGerenciarElenco()
          : TelaFormularioJogador(
              jogadorParaEditar: SessaoApp.meuPerfilJogador,
            ),
      const TelaChat(),
      const TelaPerfilUsuario(),
    ];

    return Scaffold(
      body: telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (i) => setState(() => _indiceAtual = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.edit_document),
            label: SessaoApp.isOlheiro ? 'Gerenciar' : 'Meu Currículo',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}