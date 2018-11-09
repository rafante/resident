import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:resident/entidades/banco.dart';

class Usuario {
  String chave;
  String nome;
  String telefone;
  String email;
  String urlFoto;
  Int8List imagem;
  List<Usuario> contatos;
  static Usuario _logado;

  Usuario(
      {this.chave,
      this.nome,
      this.email,
      this.telefone,
      this.urlFoto,
      this.imagem,
      this.contatos});

  static Future<FirebaseUser> firebaseUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  static Usuario logado() {
    return _logado;
  }

  static Future<Null> adicionarContato(String chave) async {
    Banco.ref()
        .child('usuarios')
        .child(_logado.chave)
        .child('contatos')
        .child(chave)
        .child('uid')
        .set(chave);
    return null;
  }

  static Future<Null> carregar() async {
    await firebaseUser().then((user) {
      if (user == null) {
        FirebaseAuth.instance.signOut();
        return null;
      }
      var uid = user.uid;
      Banco.ref().child('usuarios').child(uid).onValue.listen((evento) {
        Map usuario = evento.snapshot.value;
        if (usuario == null) {
          FirebaseAuth.instance.signOut();
          return null;
        }
        _logado = Usuario(
            chave: usuario['uid'],
            nome: usuario['displayName'],
            email: usuario['email'],
            telefone: usuario['telefone'],
            urlFoto: usuario['photoURL']);
        _logado.contatos = [];
        Map contatos = usuario['contatos'];
        if (contatos != null) {
          contatos.forEach((contKey, contValue) {
            var contato = Usuario(
                chave: contValue['uid'],
                nome: contValue['displayName'],
                email: contValue['email'],
                urlFoto: contValue['photoURL'],
                telefone: contValue['telefone']);
            _logado.contatos.add(contato);
          });
        }
      });
    });
    return null;
  }
}

class Usuarios {
  static FirebaseUser _usuarioLogado;
  // static String _logado;
  static String logado() {
    if (_usuarioLogado == null) {
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        _usuarioLogado = _usuarioLogado;
      });
    }
    return _usuarioLogado == null ? null : _usuarioLogado.uid;
  }

  static void setLogado(FirebaseUser user) {
    _usuarioLogado = user;
  }

  static Future<void> deslogar() async {
    return await FirebaseAuth.instance.signOut().then((teste) {
      _usuarioLogado = null;
    });
  }
}
