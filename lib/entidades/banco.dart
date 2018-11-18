import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resident/imports.dart';

typedef void AssinaturaBanco(Map<String, dynamic> documentos);

class Banco {
  static bool _firstTime = true;

  static Map<String, dynamic> _usuarios = Map();
  static Map<String, dynamic> _grupos = Map();
  static Map<String, dynamic> _pacientes = Map();
  static Map<String, dynamic> _notificacoes = Map();
  static List<AssinaturaBanco> _observadoresUsuarios;
  static List<AssinaturaBanco> _observadoresGrupos;
  static List<AssinaturaBanco> _observadoresPacientes;
  static List<AssinaturaBanco> _observadoresNotificacoes;

  static void setup() async {
    if (_firstTime) {
      _firstTime = false;
      _observadoresUsuarios = [];
      _observadoresGrupos = [];
      _observadoresPacientes = [];
      _observadoresNotificacoes = [];
      FirebaseDatabase.instance.setPersistenceEnabled(true);
      await _manterContatos();
      await _manterGrupos();
      await _manterPacientes();
      await _manterNotificacoes();
    }
  }

  static Map<String, dynamic> usuarios() {
    setup();
    return _usuarios;
  }

  static Map<String, dynamic> grupos() {
    setup();
    return _grupos;
  }

  static Map<String, dynamic> pacientes() {
    setup();
    return _pacientes;
  }

  static Map<String, dynamic> notificacoes() {
    setup();
    return _notificacoes;
  }

  static void assinarUsuarios(AssinaturaBanco observador) {
    setup();
    _observadoresUsuarios.add(observador);
  }

  static void assinarGrupos(AssinaturaBanco observador) {
    setup();
    _observadoresGrupos.add(observador);
  }

  static void assinarPacientes(AssinaturaBanco observador) {
    setup();
    _observadoresPacientes.add(observador);
  }

  static void assinarNotificacoes(AssinaturaBanco observador) {
    setup();
    _observadoresNotificacoes.add(observador);
  }

  static Future<void> _manterGrupos() async {
    Firestore.instance
        .collection('grupos')
        .where('contatos', arrayContains: Usuario.eu['uid'])
        .snapshots()
        .listen((snap) {
      _grupos = Map();
      snap.documents.forEach((documento) {
        _grupos.putIfAbsent(documento.documentID, () {
          Map grupo = Map();
          grupo['nome'] = documento.data['nome'];
          grupo['descricao'] = documento.data['descricao'];
          return grupo;
        });
      });
      _observadoresGrupos.forEach((observador) {
        observador(_grupos);
      });
    });
  }

  static Future<void> _manterPacientes() async {
    _pacientes = Map();
    Firestore.instance.collection('pacientes').snapshots().listen((snap) {
      _pacientes = Map();
      snap.documents.forEach((documento) {
        _pacientes.putIfAbsent(documento.documentID, () {
          Map paciente = Map();
          paciente['nome'] = documento.data['nome'];
          paciente['entrada'] = documento.data['nome'];
          paciente['telefone'] = documento.data['telefone'];
          paciente['grupo'] = documento.data['grupo'];
          documento.data['usuarios'].forEach((usuario) {
            paciente['usuarios'].add(usuario);
          });
          return paciente;
        });
      });
      _observadoresPacientes.forEach((observador) {
        observador(_pacientes);
      });
    });
  }

  static Future<void> _manterContatos() async {
    Firestore.instance.collection('usuarios').snapshots().listen((snap) {
      _usuarios = Map();
      snap.documents.forEach((documento) {
        _usuarios.putIfAbsent(documento.documentID, () {
          Map<String, dynamic> dados = Map();
          dados['nome'] = documento.data['displayName'];
          dados['desabilitado'] = documento.data['disabled'];
          dados['email'] = documento.data['email'];
          dados['emailVerificado'] = documento.data['emailVerified'];
          dados['idResidente'] = documento.data['idResidente'];
          dados['telefone'] = documento.data['phone'];
          dados['urlFoto'] = documento.data['photoURL'];
          dados['uid'] = documento.data['uid'];
          return dados;
        });
      });
      _observadoresGrupos.forEach((observador) {
        observador(_usuarios);
      });
    });
  }

  static Future<void> _manterNotificacoes() async {
    _notificacoes = Map();
    Firestore.instance
        .collection('notificacoes')
        .document(Usuario.eu['uid'])
        .collection('grupos')
        .snapshots()
        .listen((snap) {
      snap.documents.forEach((notificacao) {
        _notificacoes[notificacao.documentID] = notificacao.data;
      });
    });
  }

  static DatabaseReference ref() {
    if (_firstTime) {
      setup();
      _firstTime = false;
    }
    return FirebaseDatabase.instance.reference();
  }

  static void addUpdateUsuario(String documentId, Map<String, dynamic> campos) {
    Firestore.instance.collection('usuarios').document(documentId).setData({
      'nome': campos['nome'],
      'email': campos['email'],
      'emailVerificado': campos['emailVerificado'],
      'telefone': campos['telefone'],
      'urlFoto': campos['urlFoto'],
      'uid': campos['uid'],
    }, merge: true);
  }
}
