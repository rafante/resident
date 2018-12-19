import 'package:resident/imports.dart';

class HistoriaDoencaAtualPage extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;
  static String tag = 'historia-doenca-atual';

  HistoriaDoencaAtualPage({this.app, this.pacienteKey, this.grupoKey});
  _HistoriaDoencaAtualPageState createState() =>
      _HistoriaDoencaAtualPageState();
}

class _HistoriaDoencaAtualPageState extends State<HistoriaDoencaAtualPage> {
  TextEditingController _historiaDoencaAtual = TextEditingController(text: '');
  Paciente paciente;
  String nomePaciente;

  @override
  void initState() {
    nomePaciente = 'carregando...';
    carregarPaciente().then((Paciente pac) {
      if (mounted) {
        setState(() {
          paciente = pac;
          nomePaciente = paciente.nome;
          _historiaDoencaAtual.text = paciente.historiaDoencaAtual;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Navegador.tagAtual = Tag.HISTORIA_DOENCA_ATUAL;
    return Scaffold(
        appBar: AppBar(title: Text('História de Doença Atual')),
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
                controller: _historiaDoencaAtual,
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
                      Tela.de(context).y(15.0),
                    ),
                    hintText: 'História de doença atual...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            paciente.setar(historiaDoencaAtual: _historiaDoencaAtual.text);
            paciente.salvar();
            Navigator.pop(context);
          },
        ));
  }

  Future<Paciente> carregarPaciente() async {
    return Paciente.buscar(widget.pacienteKey);
  }
}
