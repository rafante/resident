import 'package:resident/imports.dart';

class AplicacaoMedicamento {
  String key;
  String pacienteKey;
  String descricao;
  String tipo;
  DateTime horario;

  void salvar() {
    DocumentReference ref = key != null
        ? Firestore.instance.document('medicamentos/$key')
        : Firestore.instance.collection('medicamentos').document();
    if (key == null) key = ref.documentID;
    ref.setData({
      'key': key,
      'pacienteKey': pacienteKey,
      'descricao': descricao,
      'tipo': tipo,
      'horario': horario != null
          ? horario.millisecondsSinceEpoch
          : DateTime.now().millisecondsSinceEpoch
    });
  }

  AplicacaoMedicamento(
      {this.key,
      bool forcarOnline = false,
      this.pacienteKey,
      this.descricao,
      this.tipo,
      this.horario});

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
