import 'package:intl/intl.dart';
import 'package:resident/imports.dart';

class PacientesPage extends StatefulWidget {
  static String tag = 'pacientes-page';
  final String grupoKey;
  final FirebaseApp app;
  PacientesPage({this.app, this.grupoKey});

  @override
  _PacientesPageState createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  TextEditingController _pacienteNome = TextEditingController(text: '');
  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm:ss");

  @override
  void initState() {
    Firestore.instance
        .collection('pacientes')
        .where('grupoKey', isEqualTo: widget.grupoKey)
        .snapshots()
        .listen((snap) {
      List<Paciente> lista = <Paciente>[];

      if (snap.documents != null) {
        snap.documents.forEach((documento) {
          lista.add(Paciente(
            key: documento.documentID,
            entrada: documento.data['entrada'],
            nome: documento.data['nome'],
            telefone: documento.data['telefone'],
            hipoteseDiagnostica: documento.data['hipoteseDiagnostica'],
            historiaDoencaAtual: documento.data['historiaDoencaAtual'],
            historiaPregressa: documento.data['historiaPregressa'],
          ));
        });
      }
      if (this.mounted) {
        setState(() {
          _pacientes = lista;
        });
      }
    });
    super.initState();
  }

  List<Paciente> _pacientes = <Paciente>[];

  Future<Paciente> _popupCriaPaciente() async {
    return await showDialog<Paciente>(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
            child: SimpleDialog(
              title: Text('Paciente'),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Tela.de(context).x(30.0),
                  vertical: Tela.de(context).y(30.0)),
              children: <Widget>[
                Container(
                  width: Tela.de(context).x(300.0),
                  height: Tela.de(context).y(300.0),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _pacienteNome,
                        decoration: InputDecoration(hintText: 'Nome'),
                      ),
                      SizedBox(height: Tela.de(context).y(30.0)),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Outro dado'),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: Tela.de(context).x(80.0)),
                  color: Colors.blueAccent,
                  child: Text('Criar', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(
                        context, new Paciente(nome: _pacienteNome.text));
                  },
                )
              ],
            ),
          );
        });
  }

  void _criaPaciente() {
    Navegador.de(context).navegar(Tag.PACIENTE_DETALHE,
        {'grupoKey': widget.grupoKey, 'pacienteKey': null});
  }

  List<Card> _pacientesCard() {
    List<Card> lista = <Card>[];
    _pacientes.forEach((Paciente paciente) {
      Prefs.checarNotificacoes(paciente: paciente.key).then((int nots) {
        if (nots != paciente.notificacoes) {
          setState(() {
            paciente.notificacoes = nots;
          });
        }
      });
      lista.add(new Card(
        child: ListTile(
            leading: Icon(Icons.airline_seat_flat_angled),
            contentPadding: EdgeInsets.fromLTRB(
                Tela.de(context).x(20.0),
                Tela.de(context).y(20.0),
                Tela.de(context).x(20.0),
                Tela.de(context).y(20.0)),
            trailing: IconButton(
              icon: Stack(
                children: <Widget>[
                  Icon(Icons.settings),
                  Positioned(
                    left: Tela.de(context).x(10.0),
                    top: Tela.de(context).y(10.0),
                    child: 1 <= 0
                        ? ClipOval(
                            child: Container(
                              color: Colors.amberAccent,
                              height: Tela.de(context).y(15.0),
                              width: Tela.de(context).x(13.0),
                              child: Center(
                                child: Text(
                                  paciente.notificacoes.toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        : new Container(),
                  )
                ],
              ),
              onPressed: () {
                Navegador.de(context).navegar(Tag.PACIENTE_DETALHE, {
                  'pacienteKey': paciente.key,
                  'grupoKey': paciente.grupoKey
                });
              },
            ),
            dense: true,
            title: new Text(paciente.nome),
            subtitle: paciente.entrada != null
                ? Text(dateFormat.format(
                    DateTime.fromMillisecondsSinceEpoch(paciente.entrada)))
                : Text(''),
            onTap: () {
              setState(() {
                Navegador.de(context).navegar(Tag.PACIENTE,
                    {'grupoKey': widget.grupoKey, 'pacienteKey': paciente.key});
              });
            }),
      ));
    });
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: new Icon(Icons.airline_seat_flat),
        elevation: 1.0,
        title: Padding(
          padding: EdgeInsets.only(top: Tela.de(context).y(20.0)),
          child: Title(
              color: Colors.lightBlueAccent, child: new Text('Pacientes')),
        ),
      ),
      body: ListView(
        children: _pacientesCard(),
        // itemExtent: Tela.de(context).abs(80.0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _criaPaciente();
        },
      ),
    );
  }
}
