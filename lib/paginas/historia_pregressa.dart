import 'package:resident/imports.dart';

class HistoriaPregressaPage extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;
  static String tag = 'historia-pregressa';
  HistoriaPregressaPage({this.app, this.pacienteKey, this.grupoKey});
  _HistoriaPregressaPageState createState() => _HistoriaPregressaPageState();
}

class _HistoriaPregressaPageState extends State<HistoriaPregressaPage> {
  TextEditingController _historiaPregressa = TextEditingController(text: '');
  Paciente paciente;

  @override
  void initState() {
    paciente = new Paciente(key: widget.pacienteKey, grupoKey: widget.grupoKey);
    paciente.carregaDadosDoServidor(carregarDadosExtras: true).then((event) {
      _historiaPregressa.text = paciente.historiaPregressa;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('História Pregressa')),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Tela.de(context).x(20.0),
                  Tela.de(context).x(20.0),
                  Tela.de(context).x(20.0),
                  Tela.de(context).x(20.0)),
              child: TextFormField(
                controller: _historiaPregressa,
                maxLines: 18,
                maxLengthEnforced: true,
                onEditingComplete: () {
                  setState(() {
                    print(_historiaPregressa.text);
                  });
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(15.0),
                        Tela.de(context).y(15.0),
                        Tela.de(context).x(15.0),
                        Tela.de(context).y(15.0)),
                    hintText: 'História pregressa do paciente...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            paciente.salvarHistoriaPregressa(_historiaPregressa.text);
            paciente.salvar();
            Navigator.pop(context);
          },
        ));
  }
}
