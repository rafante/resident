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
  String idResidente = "";
  Int8List imagem;
  List<Usuario> contatos = [];
  static Map<String, Usuario> usuariosCarregados;
  static Usuario _logado;
  static Map<String, dynamic> eu;

  Usuario(
      {this.chave,
      this.nome,
      this.email,
      this.telefone,
      this.urlFoto,
      this.imagem,
      this.contatos,
      this.idResidente});

  static void setLogado(FirebaseUser user) {
    eu = Map<String, dynamic>();
    eu['nome'] = user.displayName;
    eu['email'] = user.email;
    eu['emailVerificado'] = user.isEmailVerified;
    eu['telefone'] = user.phoneNumber;
    eu['urlFoto'] = user.photoUrl;
    eu['uid'] = user.uid;
    Banco.addUpdateUsuario(user.uid, eu);
  }

  void salvar() {
    Banco.addUpdateUsuario(eu['uid'], eu);
  }

  static Future<FirebaseUser> firebaseUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  static Future<Usuario> lerResidente(String idResidente) async {
    String chave = '';
    await Banco.ref()
        .child('usuarios')
        .child('ids')
        .child(idResidente)
        .once()
        .then((snap) {
      if (snap.value == null) return null;
      ler(snap.value);
      chave = snap.value;
    });
    return ler(chave);
  }

  static Future<Usuario> ler(String chave) async {
    if (usuariosCarregados == null) usuariosCarregados = Map();
    if (chave == null || chave == '') return null;
    if (usuariosCarregados.containsKey(chave)) return usuariosCarregados[chave];
    await Banco.ref().child('usuarios').child(chave).once().then((snap) {
      if (snap.value != null) {
        usuariosCarregados[chave] = Usuario(
            chave: chave,
            email: snap.value['email'],
            idResidente: snap.value['idResidente'],
            urlFoto: snap.value['photoURL'],
            nome: snap.value['displayName'],
            telefone: snap.value['phone']);
      }
    });
    return usuariosCarregados[chave];
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

  static Future<dynamic> buscarId(String idResidente) async {
    return await Banco.ref()
        .child('usuarios')
        .child('ids')
        .child(idResidente)
        .once()
        .then((snap) {
      return snap.value;
    });
  }

  // static Future<Null> setLogado(FirebaseUser user) async {
  //   return await carregar();
  // }

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
            telefone: usuario['phone'],
            idResidente: usuario['idResidente'],
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
                telefone: contValue['phone']);
            _logado.contatos.add(contato);
          });
        }
      });
    });
    return null;
  }

  static bool estaLogado() {
    return eu != null && eu['uid'] != null;
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

  // static void setLogado(FirebaseUser user) {
  //   _usuarioLogado = user;
  // }

  static Future<void> deslogar() async {
    return await FirebaseAuth.instance.signOut().then((teste) {
      _usuarioLogado = null;
    });
  }
}
