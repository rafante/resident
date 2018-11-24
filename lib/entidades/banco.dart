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
    // if (!_firstTime) {
    // _firstTime = false;
    _observadoresUsuarios = [];
    _observadoresGrupos = [];
    _observadoresPacientes = [];
    _observadoresNotificacoes = [];
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    await _manterContatos();
    await _manterGrupos();
    await _manterPacientes();
    await _manterNotificacoes();
    // }
  }

  static CollectionReference colecao(String colecao) {
    return Firestore.instance.collection(colecao);
  }

  static DocumentReference documento(String documentoId) {
    return Firestore.instance.document(documentoId);
  }

  static void atualizarGrupo(String grupoId,
      {String nome, String descricao, List contatos}) {
    var dados = {'nome': nome, 'descricao': descricao, 'contatos': contatos};
    if (grupoId != null) {
      var ref = Firestore.instance.document('grupos/$grupoId');
      Firestore.instance.runTransaction((Transaction t) async {
        DocumentSnapshot snap = await t.get(ref);

        if (snap.exists) {
          t.update(ref, dados);
        } else {
          t.set(ref, dados);
        }
      });
    } else {
      Firestore.instance.collection('grupos').document().setData(dados);
    }
  }

  static void atualizarPaciente(String pacienteId,
      {String nome, DateTime entrada, String telefone}) {
    var ref = Firestore.instance.document('pacientes/$pacienteId');
    Firestore.instance.runTransaction((Transaction t) async {
      DocumentSnapshot snap = await t.get(ref);
      var dados = {'nome': nome, 'entrada': entrada, 'telefone': telefone};
      if (snap.exists) {
        t.update(ref, dados);
      } else {
        t.set(ref, dados);
      }
    });
  }

  static Map<String, dynamic> findGrupo(String grupoId) {
    setup();
    if (_grupos.containsKey(grupoId)) return _grupos[grupoId];
    return null;
  }

  static Map<String, dynamic> findPaciente(String pacienteId) {
    setup();
    if (_pacientes.containsKey(pacienteId)) return _pacientes[pacienteId];
    return null;
  }

  static Map<String, dynamic> findUsuario(String usuarioId) {
    setup();
    if (_usuarios.containsKey(usuarioId)) return _usuarios[usuarioId];
    return null;
  }

  static Map<String, dynamic> findUsuarioPorResidente(String idResidente) {
    setup();
    Map<String, dynamic> usuarioEncontrado;
    _usuarios.forEach((String chave, dynamic usuario) {
      if (usuario['idResidente'] == idResidente) {
        usuarioEncontrado = usuario;
      }
    });
    return usuarioEncontrado;
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
    if(Usuario.uid == null)
      return;
    Firestore.instance
        .collection('grupos')
        .where('contatos', arrayContains: Usuario.uid)
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
          dados['nome'] = documento.data['nome'];
          dados['desabilitado'] = documento.data['desabilitado'];
          dados['email'] = documento.data['email'];
          dados['emailVerificado'] = documento.data['emailVerificado'];
          dados['idResidente'] = documento.data['idResidente'];
          dados['telefone'] = documento.data['telefone'];
          dados['urlFoto'] = documento.data['urlFoto'];
          dados['uid'] = documento.data['uid'];
          return dados;
        });
      });
      _observadoresUsuarios.forEach((observador) {
        observador(_usuarios);
      });
    });
  }

  static Future<void> _manterNotificacoes() async {
    if(Usuario.uid == null)
      return;
    _notificacoes = Map();
    Firestore.instance
        .collection('notificacoes')
        .document(Usuario.uid)
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
    if (documentId == null) documentId = Usuario.eu['uid'];
    DocumentReference ref = Firestore.instance.document('usuarios/$documentId');
    Firestore.instance.runTransaction((Transaction t) async {
      var snap = await t.get(ref);
      if (snap.exists) {
        await t.update(ref, campos);
      } else {
        await t.set(ref, campos);
      }
    });
  }

  static Future<Map<String,dynamic>> criarUsuario(String documentId, Map<String, dynamic> campos) {
    if (documentId == null) documentId = Usuario.eu['uid'];
    DocumentReference ref = Firestore.instance.document('usuarios/$documentId');
    return Firestore.instance.runTransaction((Transaction t) async {
      var snap = await t.get(ref);
      if (!snap.exists) {
        await t.set(ref, campos);
      }
      return campos;
    });
  }
}
