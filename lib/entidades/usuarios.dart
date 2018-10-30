import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

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
