import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class DadosGrupo {
  String chave;
  String nome;
  String descricao;
  List<String> contatos;
  DatabaseReference _ref;

  void salvar() {
    if (chave == null || chave == "") chave = _ref.child('grupos').push().key;
    _ref.child('grupos').child(chave).child('nome').set(nome.trim());
    _ref.child('grupos').child(chave).child('descricao').set(descricao.trim());
  }

  void getRef(){
    if (_ref == null) _ref = FirebaseDatabase.instance.reference();
  }

  Future<DadosGrupo> getDados() async{
    await _ref.child('grupos').child(chave).once().then((DataSnapshot snapshot){
      Map dados = snapshot.value;
      nome = dados['nome'];
      descricao = dados['descricao'];
    });
    return this;
  }

  Future<bool> deletar() async {
    await _ref.child('grupos').child('chave').remove();
    return true;
  }

  DadosGrupo({this.chave = ''}) {
    if(chave == ''){
      nome = '';
      descricao = '';
      contatos = [];
      getRef();
    }else{
      getRef();
    }
  }
}
