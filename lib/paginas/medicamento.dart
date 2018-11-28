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
    aplicacao = new AplicacaoMedicamento(
        pacienteKey: widget.pacienteKey, key: widget.medicamentoKey);
    if (widget.medicamentoKey != null && widget.medicamentoKey != "")
      aplicacao.carregarDadosDoServidor().then((evento) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tipo')),
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
                      aplicacao.salvarHorario(novaData);
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
          aplicacao.salvarTipo(_tipo.text);
          aplicacao.salvarDescricao(_descricao.text);

          aplicacao.salvar();
          Navigator.pop(context);
        },
      ),
    );
  }
}
