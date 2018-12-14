import 'package:intl/intl.dart';
import 'package:resident/imports.dart';

class MedicamentoDetalhe extends StatefulWidget {
  static String tag = 'medicamento-detalhe';
  final String medicamentoKey;
  final String pacienteKey;

  MedicamentoDetalhe({this.pacienteKey, this.medicamentoKey});
  _MedicamentoDetalheState createState() => _MedicamentoDetalheState();
}

class _MedicamentoDetalheState extends State<MedicamentoDetalhe> {
  AplicacaoMedicamento aplicacao;
  TextEditingController _descricao = TextEditingController(text: '');
  TextEditingController _tipo = TextEditingController(text: '');
  TextEditingController _horario = TextEditingController(text: '');

  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  DateTime horario;

  @override
  void initState() {
    carregarMedicamento().then((AplicacaoMedicamento aplic) {
      if (mounted) {
        aplicacao = aplic;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medicamento')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Tela.de(context).x(20.0),
          Tela.de(context).y(20.0),
          Tela.de(context).x(20.0),
          Tela.de(context).y(20.0),
        ),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _tipo,
              onEditingComplete: () {
                setState(() {
                  print('.');
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    Tela.de(context).x(15.0),
                    Tela.de(context).y(15.0),
                    Tela.de(context).x(15.0),
                    Tela.de(context).y(15.0),
                  ),
                  hintText: 'Tipo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Tela.de(context).y(20.0)),
              child: DateTimePickerFormField(
                controller: _horario,
                format: dateFormat,
                onChanged: (DateTime novaData) {
                  if (novaData != null) {
                    setState(() {
                      horario = novaData;
                    });
                  }
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(15.0),
                        Tela.de(context).y(15.0),
                        Tela.de(context).x(15.0),
                        Tela.de(context).y(15.0)),
                    hintText: 'Horário',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ),
            TextFormField(
              controller: _descricao,
              maxLines: 8,
              maxLengthEnforced: true,
              onEditingComplete: () {
                setState(() {
                  print('.');
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                      Tela.de(context).x(15.0),
                      Tela.de(context).y(15.0),
                      Tela.de(context).x(15.0),
                      Tela.de(context).y(15.0)),
                  hintText: 'Descrição',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done_outline),
        onPressed: () {
          if(aplicacao == null)
            aplicacao = AplicacaoMedicamento(pacienteKey: widget.pacienteKey);
          aplicacao.salvarTipo(_tipo.text);
          aplicacao.salvarDescricao(_descricao.text);
          aplicacao.salvarHorario(horario);
          aplicacao.salvar();
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<AplicacaoMedicamento> carregarMedicamento() async {
    AplicacaoMedicamento medicamento;
    Firestore.instance
        .document('medicamentos/${widget.medicamentoKey}')
        .snapshots()
        .first
        .then((snap) {
      if (snap.data != null) {
        DateTime data = snap.data['horario'] != null
            ? DateTime.fromMillisecondsSinceEpoch(snap.data['horario'])
            : DateTime.now();
        medicamento = AplicacaoMedicamento(
            descricao: snap.data['descricao'],
            horario: data,
            key: snap.documentID,
            pacienteKey: snap.data['pacienteKey'],
            tipo: snap.data['tipo']);
      }
    });
    return medicamento;
  }
}
