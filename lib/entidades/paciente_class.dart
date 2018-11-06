import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:resident/entidades/banco.dart';

class Paciente {
  String nome;
  String telefone;
  DateTime entrada;
  String historiaPregressa;
  String historiaDoencaAtual;
  String hipoteseDiagnostica;
  String grupoKey;
  String key;
  int notificacoes = 0;
  DatabaseReference ref;

  void salvar() {
    ref
        .child('grupos')
        .child(grupoKey)
        .child('pacientes')
        .child(key)
        .child('nome')
        .set(this.nome);
    ref
        .child('grupos')
        .child(grupoKey)
        .child('pacientes')
        .child(key)
        .child('telefone')
        .set(this.telefone);
    if (entrada != null)
      ref
          .child('grupos')
          .child(grupoKey)
          .child('pacientes')
          .child(key)
          .child('entrada')
          .set(this.entrada.millisecondsSinceEpoch);
    if (historiaPregressa != null && historiaPregressa != "") {
      ref
          .child('pacientes')
          .child(key)
          .child('historiaPregressa')
          .set(historiaPregressa);
    }
    if (historiaDoencaAtual != null && historiaDoencaAtual != "") {
      ref
          .child('pacientes')
          .child(key)
          .child('historiaDoencaAtual')
          .set(historiaDoencaAtual);
    }
    if (hipoteseDiagnostica != null && hipoteseDiagnostica != "") {
      ref
          .child('pacientes')
          .child(key)
          .child('hipoteseDiagnostica')
          .set(hipoteseDiagnostica);
    }
  }

  void salvaNome(String nome) {
    this.nome = nome;
  }

  void salvarHistoriaPregressa(String historia) {
    this.historiaPregressa = historia;
  }

  void salvaEntrada(DateTime entrada) {
    this.entrada = entrada;
  }

  void salvaTelefone(String telefone) {
    this.telefone = telefone;
  }

  Future<Null> carregaDadosDoServidor(
      {bool carregarDadosExtras = false}) async {
    await ref
        .child('grupos')
        .child(grupoKey)
        .child('pacientes')
        .child(key)
        .once()
        .then((snapshot) {
      Map paciente = snapshot.value;
      if (paciente != null) nome = paciente['nome'];
      if (entrada != null)
        entrada = DateTime.fromMillisecondsSinceEpoch(paciente['entrada']);
      telefone = paciente['telefone'];
    });
    if (carregarDadosExtras) {
      await ref.child('pacientes').child(key).once().then((snapshot) {
        Map paciente = snapshot.value;
        historiaPregressa = paciente['historiaPregressa'];
        historiaDoencaAtual = paciente['historiaDoencaAtual'];
        hipoteseDiagnostica = paciente['hipoteseDiagnostica'];
      });
    }
  }

  Paciente(
      {this.key,
      this.grupoKey,
      this.nome,
      this.entrada,
      this.telefone,
      bool forcarOnline = false}) {
    if (ref == null) ref = Banco.ref();
    if (key == null || key == "") {
      key = ref.child('grupos').child(grupoKey).child('pacientes').push().key;
    } else {
      if (forcarOnline) carregaDadosDoServidor();
    }
  }

  void salvarHistoriaDoencaAtual(String historiaDoencaAtual) {
    this.historiaDoencaAtual = historiaDoencaAtual;
  }

  void salvarHipoteseDiagnostica(String hipoteseDiagnostica) {
    this.hipoteseDiagnostica = hipoteseDiagnostica;
  }
}
