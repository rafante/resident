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
  String nomePaciente = 'carregando...';

  @override
  void initState() {
    carregarPaciente().then((Paciente pac) {
      if (mounted) {
        setState(() {
          paciente = pac;
          nomePaciente = paciente.nome;
          _historiaPregressa.text = paciente.historiaPregressa;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Navegador.tagAtual = Tag.HISTORIA_PREGRESSA;
    return Scaffold(
        appBar: AppBar(title: Text('História Pregressa')),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Tela.de(context).x(25.0),
                  Tela.de(context).x(15.0),
                  Tela.de(context).x(15.0),
                  Tela.de(context).x(0.0)),
              child: Text(
                'Paciente: $nomePaciente',
                style: TextStyle(fontSize: Tela.de(context).abs(17.0)),
              ),
            ),
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
                    print('.');
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
            paciente.setar(historiaPregressa: _historiaPregressa.text);
            paciente.salvar();
            Navigator.pop(context);
          },
        ));
  }

  Future<Paciente> carregarPaciente() async {
    return Paciente.buscar(widget.pacienteKey);
  }
}
