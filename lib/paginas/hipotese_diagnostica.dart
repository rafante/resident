import 'package:resident/imports.dart';

class HipoteseDiagnosticaPage extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;

  static String tag = 'hipotese-diagnostica';
  HipoteseDiagnosticaPage({this.app, this.pacienteKey, this.grupoKey});
  _HipoteseDiagnosticaPageState createState() =>
      _HipoteseDiagnosticaPageState();
}

class _HipoteseDiagnosticaPageState extends State<HipoteseDiagnosticaPage> {
  TextEditingController _hipoteseDiagnostica = TextEditingController(text: '');
  Paciente paciente;
  String nomePaciente = 'carregando...';

  @override
  void initState() {
    carregarPaciente().then((Paciente pac) {
      if (mounted) {
        setState(() {
          paciente = pac;
          nomePaciente = paciente.nome;
          _hipoteseDiagnostica.text = paciente.hipoteseDiagnostica;
        });
      }
    });
    // paciente.carregaDadosDoServidor(carregarDadosExtras: true).then((event) {
    //   _hipoteseDiagnostica.text = paciente.hipoteseDiagnostica;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Navegador.tagAtual = Tag.HIPOTESE_DIAGNOSTICA;
    return Scaffold(
        appBar: AppBar(title: Text('História Diagnostica')),
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
                  Tela.de(context).y(20.0),
                  Tela.de(context).x(20.0),
                  Tela.de(context).y(20.0)),
              child: TextFormField(
                controller: _hipoteseDiagnostica,
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
                    hintText: 'Hipótese diagnóstica...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            paciente.setar(hipoteseDiagnostica: _hipoteseDiagnostica.text);
            paciente.salvar();
            Navigator.pop(context);
          },
        ));
  }

  Future<Paciente> carregarPaciente() async {
    return Paciente.buscar(widget.pacienteKey);
  }
}
