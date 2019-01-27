import 'package:resident/imports.dart';

class Mensagem {
  String chave;
  String pacienteKey;
  String autor;
  String autorNome;
  String texto;
  DateTime hora;
  String link;
  String audio;

  Mensagem(
      {this.autor,
      this.autorNome,
      this.pacienteKey,
      this.texto,
      this.hora,
      this.chave,
      this.link,
      this.audio});

  static Future<Mensagem> criar(String pacienteKey,
      {String autor,
      String autorNome,
      String texto,
      DateTime hora,
      String link,
      String audio}) async {
    DocumentReference ref =
        Firestore.instance.collection('mensagens').document();
    if (autor == null) autor = Usuario.eu['uid'];
    if (autorNome == null) autorNome = Usuario.eu['idResidente'];
    if (hora == null) hora = DateTime.now();
    if (texto == null) texto = '';

    Mensagem mensagem = Mensagem(
        chave: ref.documentID,
        autor: autor,
        autorNome: autorNome,
        hora: hora,
        link: link,
        pacienteKey: pacienteKey,
        texto: texto,
        audio: audio);
    ref.setData({
      'chave': mensagem.chave,
      'pacienteKey': mensagem.pacienteKey,
      'autor': mensagem.autor,
      'autorNome': mensagem.autorNome,
      'texto': mensagem.texto,
      'hora': mensagem.hora.millisecondsSinceEpoch,
      'link': mensagem.link,
      'audio': mensagem.audio
    });
    return mensagem;
  }

  void setar(
      {String chave,
      String pacienteKey,
      String autor,
      String autorNome,
      String texto,
      DateTime hora,
      String link,
      String audio}) {
    if (chave != null) this.chave = chave;
    if (pacienteKey != null) this.pacienteKey = pacienteKey;
    if (autor != null) this.autor = autor;
    if (autor != null) this.autorNome = autorNome;
    if (hora != null) this.hora = hora;
    if (link != null) this.link = link;
    if (texto != null) this.texto = texto;
    if (audio != null) this.audio = audio;
  }

  Future<Mensagem> carregar() async {
    DocumentReference ref = Firestore.instance.document('mensagem/$chave');
    await ref.snapshots().first.then((documento) {
      if (documento != null && documento.data != null) {
        this.chave = documento.data['chave'];
        this.pacienteKey = documento.data['pacienteKey'];
        this.autor = documento.data['autor'];
        this.autorNome = documento.data['autorNome'];
        this.hora = documento.data['hora'] != null
            ? DateTime.fromMillisecondsSinceEpoch(documento.data['hora'])
            : DateTime.now();
        this.link = documento.data['link'];
        this.audio = documento.data['audio'];
      }
    });
    return this;
  }

  Future<Null> deletar() async {
    DocumentReference ref = Firestore.instance.document('mensagens/$chave');
    await ref.delete();
  }

  Future<Null> salvar() async {
    DocumentReference ref = Firestore.instance.document('mensagens/$chave');
    ref.setData({
      'chave': chave,
      'pacienteKey': pacienteKey,
      'autor': autor,
      'autorNome': autorNome,
      'texto': texto,
      'hora': hora.millisecondsSinceEpoch,
      'link': link,
      'audio': audio
    });
  }
}
