import 'package:resident/imports.dart';

class Paciente {
  String key;
  String grupoKey;
  String nome;
  String telefone;
  String historiaPregressa;
  String historiaDoencaAtual;
  String hipoteseDiagnostica;
  int entrada;
  int notificacoes = 0;

  Paciente(
      {this.key,
      this.grupoKey,
      this.nome,
      this.telefone,
      this.entrada,
      this.notificacoes,
      this.historiaPregressa,
      this.hipoteseDiagnostica,
      this.historiaDoencaAtual});

  static Future<Paciente> criar(String grupo) async {
    DocumentReference ref =
        Firestore.instance.collection('pacientes').document();
    await ref.setData({
      'key': ref.documentID,
      'grupoKey': grupo,
      'nome': '',
      'entrada': DateTime.now().millisecondsSinceEpoch,
      'telefone': '',
      'notificacoes': 0
    });
    return Paciente(key: ref.documentID, grupoKey: grupo);
  }

  static Future<Paciente> buscar(String documentId) async {
    if (documentId == null) return null;
    DocumentReference ref =
        Firestore.instance.document('pacientes/$documentId');
    Paciente paciente;
    await ref.get().then((snap) {
      if (snap == null && snap.data == null) {
        paciente = Paciente();
      } else {
        paciente = Paciente(
            key: snap.documentID,
            grupoKey: snap.data['grupoKey'],
            nome: snap.data['nome'],
            entrada: snap.data['entrada'],
            telefone: snap.data['telefone'],
            notificacoes: snap.data['notificacoes'],
            historiaPregressa: snap.data['historiaPregressa'],
            hipoteseDiagnostica: snap.data['hipoteseDiagnostica'],
            historiaDoencaAtual: snap.data['historiaDoencaAtual']);
      }
    });

    return paciente;
  }

  void setar({
    String nome,
    int entrada,
    String telefone,
    String historiaPregressa,
    String historiaDoencaAtual,
    String hipoteseDiagnostica,
  }) {
    if (nome != null) this.nome = nome;
    if (entrada != null) this.entrada = entrada;
    if (telefone != null) this.telefone = telefone;
    if (historiaPregressa != null) this.historiaPregressa = historiaPregressa;
    if (historiaDoencaAtual != null)
      this.historiaDoencaAtual = historiaDoencaAtual;
    if (hipoteseDiagnostica != null)
      this.hipoteseDiagnostica = hipoteseDiagnostica;
  }

  void salvar() async {
    await Firestore.instance.document('pacientes/$key').setData({
      'grupoKey': grupoKey,
      'nome': nome,
      'entrada': entrada,
      'telefone': telefone,
      'historiaPregressa': historiaPregressa,
      'historiaDoencaAtual': historiaDoencaAtual,
      'hipoteseDiagnostica': hipoteseDiagnostica
    });
  }
}
