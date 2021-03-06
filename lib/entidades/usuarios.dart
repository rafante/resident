import 'dart:typed_data';

import 'package:resident/imports.dart';

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
  static String uid;

  Usuario(
      {this.chave,
      this.nome,
      this.email,
      this.telefone,
      this.urlFoto,
      this.imagem,
      this.contatos,
      this.idResidente});

  static Future<Null> setLogado(BuildContext context, FirebaseUser user) async {
    if (user == null) {
      eu = null;
      return null;
    }
    uid = user.uid;

    DocumentReference ref = Firestore.instance.document('usuarios/$uid');

    await ref.snapshots().first.then((snap) {
      var map = snap.exists
          ? {
              'nome': snap.data['nome'],
              'email': snap.data['email'],
              'telefone': snap.data['telefone'],
              'urlFoto': snap.data['urlFoto'],
              'idResidente': snap.data['idResidente'],
              'uid': snap.data['uid'],
              'contatos': snap.data['contatos'],
            }
          : {
              'nome': user.displayName,
              'email': user.email,
              'telefone': user.phoneNumber,
              'urlFoto': user.photoUrl,
              'idResidente': '',
              'uid': user.uid,
              'contatos': []
            };
      if (!snap.exists) {
        ref.setData(map);
      }
      eu = map;
      setarUsuarioLocal();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext cont) {
        return BaseWindow();
      }));
    });
    print('pulou fora');
    // var lock = new Lock();
    // await lock.synchronized(() async {
    //   ref.snapshots().listen((snap) {});
    // });
  }

  static void setarUsuarioLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nome = eu['nome'] != null ? eu['nome'] : "";
    String email = eu['email'] != null ? eu['email'] : "";
    String telefone = eu['telefone'] != null ? eu['telefone'] : "";
    String urlFoto = eu['urlFoto'] != null ? eu['urlFoto'] : "";
    String idResidente = eu['idResidente'] != null ? eu['idResidente'] : "";
    String uid = eu['uid'] != null ? eu['uid'] : "";
    prefs.setStringList('usuario_logado', [
      nome,
      email,
      telefone,
      urlFoto,
      idResidente,
      uid
    ]);
    List<String> contatos = [];
    if (eu['contatos'] != null) {
      eu['contatos'].forEach((cont) {
        contatos.add(cont);
      });
    }
    prefs.setStringList('contatos', contatos);
  }

  static Future<Null> carregarUsuarioLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userData = prefs.getStringList('usuario_logado');
    List<String> contatos = prefs.getStringList('contatos');
    if (userData != null) {
      if (contatos == null) contatos = [];
      eu = {
        'nome': userData[0],
        'email': userData[1],
        'telefone': userData[2],
        'urlFoto': userData[3],
        'idResidente': userData[4],
        'uid': userData[5],
        'contatos': contatos
      };
    }
  }

  static void limparUsuarioLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void manterUsuarioLogado() {
    Banco.documento('usuarios/$uid').snapshots().listen((snap) {
      eu = snap.data;
      if (eu != null) {
        List contatos = eu['contatos'];
        eu['contatos'] = [];
        eu['contatos'].addAll(contatos);
      }
    });
  }

  static void salvar() {
    Banco.addUpdateUsuario(eu['uid'], eu);
    setarUsuarioLocal();
  }

  static Future<FirebaseUser> firebaseUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  static Future<Map<String, dynamic>> lerResidente(String idResidente) async {
    return Banco.findUsuarioPorResidente(idResidente);
  }

  static Future<Usuario> ler(String chave) async {
    if (usuariosCarregados == null) usuariosCarregados = Map();
    if (chave == null || chave == '') return null;
    if (usuariosCarregados.containsKey(chave)) return usuariosCarregados[chave];
    // await Banco.ref().child('usuarios').child(chave).once().then((snap) {
    //   if (snap.value != null) {
    //     usuariosCarregados[chave] = Usuario(
    //         chave: chave,
    //         email: snap.value['email'],
    //         idResidente: snap.value['idResidente'],
    //         urlFoto: snap.value['photoURL'],
    //         nome: snap.value['displayName'],
    //         telefone: snap.value['phone']);
    //   }
    // });
    return usuariosCarregados[chave];
  }

  // static Usuario logado() {
  //   return _logado;
  // }

  static void adicionarContato(String chave) {
    if (eu['contatos'] == null) eu['contatos'] = List;
    List conts = [];
    conts.addAll(eu['contatos']);
    if (!conts.contains(chave)) conts.add(chave);
    eu['contatos'] = conts;
  }

  static Future<dynamic> buscarId(String idResidente) async {
    return await Banco.colecao('usuarios')
        .where('idResidente', isEqualTo: idResidente)
        .snapshots()
        .first
        .then((snap) {
      return snap.documents.length > 0 ? snap.documents[0] : null;
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
      // Banco.ref().child('usuarios').child(uid).onValue.listen((evento) {
      //   Map usuario = evento.snapshot.value;
      //   if (usuario == null) {
      //     FirebaseAuth.instance.signOut();
      //     return null;
      //   }
      //   _logado = Usuario(
      //       chave: usuario['uid'],
      //       nome: usuario['displayName'],
      //       email: usuario['email'],
      //       telefone: usuario['phone'],
      //       idResidente: usuario['idResidente'],
      //       urlFoto: usuario['photoURL']);
      //   _logado.contatos = [];
      //   Map contatos = usuario['contatos'];
      //   if (contatos != null) {
      //     contatos.forEach((contKey, contValue) {
      //       var contato = Usuario(
      //           chave: contValue['uid'],
      //           nome: contValue['displayName'],
      //           email: contValue['email'],
      //           urlFoto: contValue['photoURL'],
      //           telefone: contValue['phone']);
      //       _logado.contatos.add(contato);
      //     });
      //   }
      // });
    });
    return null;
  }

  static bool valido() {
    return estaLogado() &&
        eu['idResidente'] != null &&
        eu['idResidente'] != "" &&
        eu['telefone'] != null &&
        eu['telefone'] != "";
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
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signOut();
    return await FirebaseAuth.instance.signOut().then((teste) {
      _usuarioLogado = null;
    });
  }
}
