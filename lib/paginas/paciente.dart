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
  bool carregando = false;
  TextEditingController _textController = TextEditingController(text: '');
  bool _isWriting = false;
  String nomePaciente = '';
  Paciente paciente;
  bool _gravando = false;
  FlutterSound flutterSound = new FlutterSound();

  @override
  void initState() {
    super.initState();
    paciente = Paciente();
    Paciente.buscar(widget.pacienteKey).then((Paciente pac) {
      if (pac != null && mounted) {
        paciente = pac;
        setState(() {
          nomePaciente = paciente.nome;
        });
      }
    });
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
            audio: documento.data['audio'],
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
    Navegador.tagAtual = Tag.PACIENTE;
    Prefs.lerNotificacoes(widget.pacienteKey);
    return Scaffold(
      appBar: AppBar(
          elevation: 1.0,
          title: Padding(
            padding: EdgeInsets.only(top: Tela.de(context).x(20.0)),
            child: Text(nomePaciente),
          )),
      body: _body(),
      endDrawer: Drawer(
        elevation: 1.0,
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: Icon(Icons.assignment),
              title: Text('Exames'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext cont) {
                  return BaseWindow(
                      conteudo: ExamesPage(
                    grupoKey: widget.grupoKey,
                    pacienteKey: widget.pacienteKey,
                    pacienteNome: paciente.nome,
                  ));
                }));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.pills),
              title: Text('Medicamentos'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext cont) {
                  return BaseWindow(
                      conteudo: MedicamentosPage(
                    grupoKey: widget.grupoKey,
                    pacienteKey: widget.pacienteKey,
                  ));
                }));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.stethoscope),
              title: Text('História de Doença Atual'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext cont) {
                  return BaseWindow(
                      conteudo: HistoriaDoencaAtualPage(
                    pacienteKey: widget.pacienteKey,
                    grupoKey: widget.grupoKey,
                  ));
                }));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.scroll),
              title: Text('História Pregressa'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext cont) {
                  return BaseWindow(
                      conteudo: HistoriaPregressaPage(
                    grupoKey: widget.grupoKey,
                    pacienteKey: widget.pacienteKey,
                  ));
                }));
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.edit),
              title: Text('Hipótese Diagnóstica'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext cont) {
                  return BaseWindow(
                      conteudo: HipoteseDiagnosticaPage(
                    grupoKey: widget.grupoKey,
                    pacienteKey: widget.pacienteKey,
                  ));
                }));
              },
            ),
            // ListTile(
            //   trailing: Icon(FontAwesomeIcons.hospital),
            //   title: Text('Alta do paciente'),
            //   onTap: () {
            //     Navegador.de(context).navegar(Tag.ALTA_PACIENTE, {
            //       'pacienteKey': widget.pacienteKey,
            //       'grupoKey': widget.grupoKey
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    List<Widget> widgets = [];
    widgets.add(Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            itemBuilder: (context, int indice) {
              Mensagem msg = _mensagens[indice];
              if (msg.audio != null) {
                //Se é uma mensagem de áudio, verifica se ela já foi baixada, caso contrário, baixa-a
                String colecao = msg.audio.split('\/')[1];
                String arquivoNome = msg.audio.split('\/').last;
                DownloadUpload.download(colecao, arquivoNome);
              }
              String horaFormatada = DateFormat('HH:mm').format(msg.hora);
              return Bubble(
                  message: msg.audio != null
                      ? msg.audio.split('\/').last
                      : msg.texto,
                  time: horaFormatada,
                  autor: msg.autorNome,
                  audio: msg.audio != null,
                  link: msg.link,
                  onTap: () {
                    if (msg.link != null) {
                      loading(true);
                      Exame.abrirAnexoExame(context, ExameId: msg.link)
                          .then((_) {
                        loading(false);
                      })
                            ..catchError((_) {
                              loading(false);
                            });
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
        )
      ],
    ));
    if (carregando) {
      widgets.add(Opacity(
        opacity: 0.8,
        child: ModalBarrier(dismissible: false, color: Colors.black),
      ));
      widgets.add(Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
      ));
    }
    return Stack(
      children: widgets,
    );
  }

  void loading(bool _carregando) {
    setState(() {
      carregando = _carregando;
    });
  }

  StreamSubscription _streamGravacao;

  Widget _botaoAudio() {
    return GestureDetector(
      onTapCancel: () {
        flutterSound.stopRecorder();
        if (_streamGravacao != null) {
          _streamGravacao.cancel();
          _streamGravacao = null;
          criarMensagem(Usuario.uid, 'enviando audio...', DateTime.now())
              .then((mensagem) {
            DownloadUpload.upload(widget.pacienteKey, 'gravacao', 'mp4',
                    nomeNoBucket: mensagem.chave)
                .then((task) async {
              String link = await task.ref.getPath();
              mensagem.setar(audio: link, link: link);
              mensagem.salvar();
            });
          });
        }
      },
      onTapDown: (tap) async {
        var tempDir = await getTemporaryDirectory();
        String p = '${tempDir.path}/gravacao.mp4';
        String path = await flutterSound.startRecorder(p);
        print('startRecorder: $path');

        _streamGravacao = flutterSound.onRecorderStateChanged.listen((_) {});
      },
      child: IconButton(
        icon: Icon(Icons.keyboard_voice),
        color: Colors.black,
        onPressed: () {},
      ),
    );
  }

  IconButton _botaoAnexar() {
    return IconButton(
      icon: Icon(
        Icons.attach_file,
        color: Colors.black45,
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
                  onChanged: (String textoDigitado) {
                    setState(() {
                      _isWriting = _textController.text.length > 0;
                    });
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: 'Digite aqui')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: Tela.de(context).x(3.0)),
              child: Row(
                children: <Widget>[
                  _botaoAnexar(),
                  _botaoAudio(),
                  _isWriting
                      ? IconButton(
                          icon: Icon(
                            Icons.play_circle_filled,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            if (_textController.text == '') return;
                            criarMensagem(Usuario.uid, _textController.text,
                                DateTime.now());

                            setState(() {
                              _textController.text = '';
                              _isWriting = false;
                            });
                          },
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
