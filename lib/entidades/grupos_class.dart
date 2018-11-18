import 'package:resident/imports.dart';

class Grupo {
  String key;
  String nome;
  List<Usuario> contatos;
  int notificacoes = 0;
  Grupo({this.nome, this.key});

  static Grupo de(String documentId, Map<String, dynamic> data) {
    return Grupo(key: documentId, nome: data['nome']);
  }
}
