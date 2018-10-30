import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class AplicacaoMedicamento {
  String key;
  String pacienteKey;
  String descricao;
  String tipo;
  DateTime horario;
  DatabaseReference ref;

  Future<Null> carregarDadosDoServidor() async {
    await ref
        .child('pacientes')
        .child(pacienteKey)
        .child('medicamentos')
        .child(key)
        .once()
        .then((snapshot) {
      Map medicamento = snapshot.value;
      descricao = medicamento['descricao'];
      tipo = medicamento['tipo'];
      horario = DateTime.fromMillisecondsSinceEpoch(medicamento['horario']);
    });
  }

  void salvar() {
    var medicamento = ref
        .child('pacientes')
        .child(pacienteKey)
        .child('medicamentos')
        .child(key);
    medicamento.child('descricao').set(descricao);
    medicamento.child('tipo').set(tipo);
    if (horario != null)
      medicamento.child('horario').set(horario.millisecondsSinceEpoch);
  }

  AplicacaoMedicamento(
      {this.key,
      bool forcarOnline = false,
      this.pacienteKey,
      this.descricao,
      this.tipo,
      this.horario}) {
    if (ref == null) ref = FirebaseDatabase.instance.reference();
    if (key == null || key == '') {
      key = ref
          .child('pacientes')
          .child(pacienteKey)
          .child('medicamentos')
          .push()
          .key;
    } else {
      if (forcarOnline) carregarDadosDoServidor();
    }
  }

  void salvarTipo(String text) {
    tipo = text;
  }

  void salvarDescricao(String text) {
    descricao = text;
  }

  void salvarHorario(DateTime horario) {
    this.horario = horario;
  }
}
