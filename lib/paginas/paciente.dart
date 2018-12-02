import 'package:intl/intl.dart';
import 'package:resident/imports.dart';

class PacientePage extends StatefulWidget {
  static String tag = 'paciente-page';
  final Paciente paciente;
  final String grupoKey;
  final FirebaseApp app;
  final String pacienteKey;
  PacientePage({this.app, this.paciente, this.grupoKey, this.pacienteKey});
  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  List<Mensagem> _mensagens = <Mensagem>[];

  TextEditingController _textController = TextEditingController(text: '');
  bool _isWriting;
  Future<File> _imageFile;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('mensagens')
        .where('pacienteKey', isEqualTo: widget.pacienteKey)
        .snapshots()
        .listen((snap) {
      if (snap.documents != null) {
        List<Mensagem> mensagens = [];
        snap.documents.forEach((documento) {
          DateTime data = documento.data['hora'] != null
              ? DateTime.fromMillisecondsSinceEpoch(documento.data['hora'])
              : DateTime.now();
          Mensagem mensagem = Mensagem(
            chave: documento.documentID,
            pacienteKey: documento.data['pacienteKey'],
            autor: documento.data['autor'],
            autorNome: documento.data['autorNome'],
            hora: data,
            link: documento.data['link'],
            texto: documento.data['texto'],
          );
          mensagens.add(mensagem);
        });
        mensagens = mensagens.reversed.toList();
        if (mounted) {
          setState(() {
            _mensagens = mensagens;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Prefs.lerNotificacao(widget.grupoKey, widget.pacienteKey);
    return Scaffold(
      appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.purpleAccent,
          title: Padding(
            padding: EdgeInsets.only(top: Tela.de(context).x(20.0)),
            child: Text(widget.paciente.nome),
          )),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, int indice) {
                Mensagem msg = _mensagens[indice];
                String horaFormatada = DateFormat('HH:mm').format(msg.hora);
                return Bubble(
                    message: msg.texto,
                    time: horaFormatada,
                    autor: msg.autorNome,
                    link: msg.link != null,
                    onTap: () {
                      if (msg.link != null) {
                        Exame.abrirAnexoExame(ExameId: msg.link);
                      }
                    },
                    isMe: msg.autor == Usuario.eu['uid'],
                    delivered: true);
              },
              itemCount: _mensagens.length,
              reverse: true,
              padding: EdgeInsets.fromLTRB(
                  Tela.de(context).x(10.0),
                  Tela.de(context).y(10.0),
                  Tela.de(context).x(10.0),
                  Tela.de(context).y(10.0)),
            ),
          ),
          Divider(
            height: Tela.de(context).y(1.0),
          ),
          Container(
            child: _construirComposer(),
            decoration: BoxDecoration(color: Colors.purpleAccent),
          )
        ],
      ),
      endDrawer: Drawer(
        elevation: 1.0,
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: Icon(Icons.assignment),
              title: Text('Exames'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: ExamesPage(
                        app: widget.app,
                        pacienteKey: widget.pacienteKey,
                        grupoKey: widget.grupoKey),
                  );
                })));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.pills),
              title: Text('Medicamentos'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: MedicamentosPage(
                        app: widget.app,
                        grupoKey: widget.grupoKey,
                        pacienteKey: widget.pacienteKey),
                  );
                })));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.stethoscope),
              title: Text('História de Doença Atual'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: HistoriaDoencaAtualPage(
                        app: widget.app,
                        pacienteKey: widget.pacienteKey,
                        grupoKey: widget.grupoKey),
                  );
                })));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.scroll),
              title: Text('História Pregressa'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: HistoriaPregressaPage(
                        app: widget.app,
                        pacienteKey: widget.pacienteKey,
                        grupoKey: widget.grupoKey),
                  );
                })));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.edit),
              title: Text('Hipótese Diagnóstica'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: HipoteseDiagnosticaPage(
                        app: widget.app,
                        pacienteKey: widget.pacienteKey,
                        grupoKey: widget.grupoKey),
                  );
                })));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.hospital),
              title: Text('Alta do paciente'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: AltaPacientePage(
                        app: widget.app,
                        pacienteKey: widget.pacienteKey,
                        grupoKey: widget.grupoKey),
                  );
                })));
              },
            ),
          ],
        ),
      ),
    );
  }

  IconButton _botaoAnexar() {
    return IconButton(
      icon: Icon(
        Icons.attach_file,
        color: Colors.white,
      ),
      onPressed: () {
        Exame.criarAnexo(context, TipoExame.ANEXO, widget.pacienteKey);
      },
    );
  }

  Future<Mensagem> criarMensagem(
      String autor, String texto, DateTime hora) async {
    Mensagem mensagem = await Mensagem.criar(
      widget.pacienteKey,
      texto: texto,
      hora: hora,
      autor: autor,
    );
    mensagem.salvar();
    // DatabaseReference ref =
    //     Banco.ref().child('chats').child(widget.pacienteKey);
    // mensagem.chave = ref.push().key;
    return mensagem;
  }

  void salvarMensagem(Mensagem mensagem) {
    // DatabaseReference db = Banco.ref();
    // db = db.child('chats').child(widget.pacienteKey).child(mensagem.chave);

    // db.child('texto').set(mensagem.texto);
    // db.child('hora').set(mensagem.hora.millisecondsSinceEpoch);
    // db.child('autor').set(mensagem.autor);
  }

  Widget _construirComposer() {
    return IconTheme(
      data: new IconThemeData(color: Colors.purpleAccent),
      child: new Container(
        margin: EdgeInsets.symmetric(horizontal: Tela.de(context).x(29.0)),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: TextField(
                  controller: _textController,
                  onChanged: (String textoDigitado) {},
                  decoration:
                      InputDecoration.collapsed(hintText: 'Digite aqui')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: Tela.de(context).x(3.0)),
              child: Row(
                children: <Widget>[
                  _botaoAnexar(),
                  IconButton(
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_textController.text == '') return;
                      criarMensagem(
                          Usuario.uid, _textController.text, DateTime.now());

                      setState(() {
                        // _mensagens.add(mensagem);
                        // _mensagens = _mensagens.reversed.toList();
                        _textController.text = '';
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
