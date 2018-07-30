import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Usuarios {
  static String _logado;
  static String logado() {
    if(_logado == null){
      FirebaseAuth.instance.currentUser().then((FirebaseUser user){
        _logado = user.uid;
      });
    }
    return _logado;
  }
}