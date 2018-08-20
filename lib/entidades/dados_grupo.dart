import 'package:firebase_database/firebase_database.dart';

class DadosGrupo {
  String chave;
  String nome;
  String descricao;
  List<String> contatos;
  DatabaseReference _ref;

  void salvar() {
    if (_ref == null) _ref = FirebaseDatabase.instance.reference();
    if (chave == null || chave == "") chave = _ref.child('grupos').push().key;
    _ref.child('grupos').child(chave).child('nome').set(nome.trim());
    _ref.child('grupos').child(chave).child('descricao').set(descricao.trim());
  }

  DadosGrupo({this.nome, this.descricao, this.contatos});
}
