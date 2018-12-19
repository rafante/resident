import 'package:intl/intl.dart';
import 'package:resident/imports.dart';

class PacienteDetalhe extends StatefulWidget {
  final FirebaseApp app;
  final String grupoKey;
  final String pacienteKey;

  PacienteDetalhe({this.app, this.grupoKey, this.pacienteKey});

  @override
  _PacienteDetalheState createState() => _PacienteDetalheState();
}

class _PacienteDetalheState extends State<PacienteDetalhe> {
  TextEditingController _nome = TextEditingController(text: '');
  TextEditingController _data = TextEditingController(text: '');
  TextEditingController _telefone = TextEditingController(text: '');

  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm:ss");
  DateTime dataEntrada;
  Paciente paciente;

  @override
  void initState() {
    super.initState();
    // paciente = Paciente(grupoKey: widget.grupoKey);
    carregarPaciente().then((Paciente pac) {
      if (pac != null && mounted) {
        setState(() {
          paciente = pac;
          carregaDadosTela();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Navegador.tagAtual = Tag.PACIENTE_DETALHE;
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do paciente'),
      ),
      body: ListView(children: [
        //nome
        Padding(
          padding: EdgeInsets.fromLTRB(
              Tela.de(context).x(20.0),
              Tela.de(context).y(20.0),
              Tela.de(context).x(20.0),
              Tela.de(context).y(20.0)),
          child: TextFormField(
            controller: _nome,
            onEditingComplete: () {
              setState(() {
                // print(_nome.text);
                paciente.setar(nome: _nome.text);
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                  Tela.de(context).x(15.0),
                  Tela.de(context).y(15.0),
                  Tela.de(context).x(15.0),
                  Tela.de(context).y(15.0),
                ),
                hintText: 'Digite o nome',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            Tela.de(context).x(20.0),
            Tela.de(context).y(20.0),
            Tela.de(context).x(20.0),
            Tela.de(context).y(20.0),
          ),
          child: DateTimePickerFormField(
            controller: _data,
            format: dateFormat,
            onChanged: (DateTime novaData) {
              setState(() {
                dataEntrada = novaData;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                    Tela.de(context).x(15.0),
                    Tela.de(context).y(15.0),
                    Tela.de(context).x(15.0),
                    Tela.de(context).y(15.0)),
                hintText: 'Data de entrada',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              Tela.de(context).x(20.0),
              Tela.de(context).y(20.0),
              Tela.de(context).x(20.0),
              Tela.de(context).y(20.0)),
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: _telefone,
            onEditingComplete: () {
              setState(() {
                // print(_telefone.text);
                paciente.setar(telefone: _telefone.text);
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                    Tela.de(context).x(15.0),
                    Tela.de(context).y(15.0),
                    Tela.de(context).x(15.0),
                    Tela.de(context).y(15.0)),
                hintText: 'Telefone',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        child: Icon(Icons.done_outline),
        onPressed: () {
          setState(() {
            if (paciente == null) {
              criaPaciente().then((Paciente criado) {
                paciente = criado;
                paciente.setar(
                    nome: _nome.text,
                    entrada: dataEntrada != null
                        ? dataEntrada.millisecondsSinceEpoch
                        : DateTime.now().millisecondsSinceEpoch,
                    telefone: _telefone.text);
                paciente.salvar();
              });
            } else {
              paciente.setar(
                  nome: _nome.text,
                  entrada: dataEntrada != null
                      ? dataEntrada.millisecondsSinceEpoch
                      : DateTime.now().millisecondsSinceEpoch,
                  telefone: _telefone.text);
              paciente.salvar();
            }
            // print('salvou o cliente');
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void carregaDadosTela() {
    _nome.text = paciente.nome;
    if (paciente.entrada != null) {
      dataEntrada = DateTime.fromMillisecondsSinceEpoch(paciente.entrada);
      _data.text = dateFormat.format(dataEntrada);
    }
    _telefone.text = paciente.telefone;
  }

  Future<Paciente> criaPaciente() async {
    return await Paciente.criar(widget.grupoKey);
  }

  Future<Paciente> carregarPaciente() async {
    // if (widget.pacienteKey != null)
    return await Paciente.buscar(widget.pacienteKey);
    // else
    //   return await Paciente.criar(widget.grupoKey);
  }

  List<Widget> _getAcoes() {
    List<Widget> lista = [];
    if (widget.pacienteKey != null) {
      lista.add(RaisedButton(
        child: Icon(
          FontAwesomeIcons.ban,
          color: Colors.white,
        ),
        color: Colors.red,
        elevation: 5.0,
        onPressed: () async {
          var resposta = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Title(
                  color: Colors.black,
                  child: Text('Deseja excluir o paciente?'),
                ),
                contentPadding: EdgeInsets.symmetric(
                  // horizontal: Tela.de(context).x(3.0),
                  vertical: Tela.de(context).y(10.0),
                ),
                children: <Widget>[
                  SimpleDialogOption(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Tela.de(context).x(10.0),
                          vertical: Tela.de(context).y(15.0)),
                      child: Text(
                        'Não',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'nao');
                    },
                  ),
                  SizedBox(
                    height: Tela.de(context).y(20.0),
                  ),
                  SimpleDialogOption(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Tela.de(context).x(10.0),
                          vertical: Tela.de(context).y(10.0)),
                      color: Colors.redAccent,
                      child: Text(
                        'Sim',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'sim');
                    },
                  )
                ],
              );
            },
          );
          if (resposta == 'sim') {
            setState(() {
              Firestore.instance
                  .document('pacientes/${widget.pacienteKey}')
                  .delete()
                  .then((event) {
                Navigator.pop(context);
              });
            });
          }
        },
      ));
    }
    return lista;
  }
}
