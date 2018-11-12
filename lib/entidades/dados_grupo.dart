import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:resident/entidades/banco.dart';
import 'package:resident/entidades/usuarios.dart';

class DadosGrupo {
  String chave;
  String nome;
  String descricao;
  List<Usuario> contatos;
  DatabaseReference _ref;

  void salvar() {
    if (chave == null || chave == "") chave = _ref.child('grupos').push().key;
    _ref.child('grupos').child(chave).child('nome').set(nome.trim());
    _ref.child('grupos').child(chave).child('descricao').set(descricao.trim());
    if (contatos != null) {
      contatos.forEach((contato) {
        _ref
            .child('grupos')
            .child(chave)
            .child('contatos')
            .push()
            .child('uid')
            .set(contato.chave);
      });
    }
  }

  void getRef() {
    if (_ref == null) _ref = Banco.ref();
  }

  Future<DadosGrupo> getDados() async {
    await _ref
        .child('grupos')
        .child(chave)
        .once()
        .then((DataSnapshot snapshot) {
      Map dados = snapshot.value;
      if (dados != null) {
        nome = dados['nome'];
        descricao = dados['descricao'];
      }
    });
    return this;
  }

  Future<bool> deletar() async {
    await _ref.child('grupos').child('chave').remove();
    return true;
  }

  DadosGrupo({this.chave = ''}) {
    if (chave == '') {
      nome = '';
      descricao = '';
      contatos = [];
      getRef();
    } else {
      getRef();
    }
  }
}
