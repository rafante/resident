import 'dart:async';

import 'package:resident/entidades/usuarios.dart';

class DadosGrupo {
  String chave;
  String nome;
  String descricao;
  List<Usuario> contatos;

  Future<DadosGrupo> getDados() async {
    // await _ref
    //     .child('grupos')
    //     .child(chave)
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   Map dados = snapshot.value;
    //   if (dados != null) {
    //     nome = dados['nome'];
    //     descricao = dados['descricao'];
    //   }
    // });
    return this;
  }

  Future<bool> deletar() async {
    return true;
  }

  DadosGrupo({this.chave = ''}) {
    if (chave == '') {
      nome = '';
      descricao = '';
      contatos = [];
      // getRef();
    } else {
      // getRef();
    }
  }
}
