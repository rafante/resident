import 'package:resident/imports.dart';

class GruposPage extends StatefulWidget {
  static String tag = 'home-page';
  GruposPage({Key key, this.title, this.app}) : super(key: key);
  final FirebaseApp app;
  final String title;

  @override
  _GruposPageState createState() => new _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  // DatabaseReference db;

  Map<String, dynamic> _grupos = Map();
  Map<String, dynamic> _notificacoes = Map();
  TextEditingController _grupoNome = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('grupos')
        .where('contatos', arrayContains: Usuario.eu['uid'])
        .snapshots()
        .listen((snap) {
      Map<String, dynamic> grps = Map();
      grps.clear();
      snap.documents.forEach((documento) {
        grps.putIfAbsent(documento.documentID, () {
          Map doc = documento.data;
          doc['key'] = documento.documentID;
          return doc;
        });
      });
      setState(() {
        _grupos = grps;
      });
    });
  }

  List<Card> _gruposCards() {
    List<Card> lista = <Card>[];
    // print(_grupos);
    _grupos.forEach((chave, grupo) {
      lista.add(new Card(
        child: new ListTile(
          leading: Icon(Icons.group),
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
                              grupo['notificacoes'].toString(),
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        )
                      : new Container(),
                )
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BaseWindow(
                    conteudo: DadosGrupoPage(
                  grupoChave: grupo['key'],
                ));
              }));
            },
          ),
          dense: true,
          title: new Text(grupo['nome'] != null ? grupo['nome'] : ''),
          subtitle:
              new Text(grupo['descricao'] != null ? grupo['descricao'] : ''),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BaseWindow(
                        conteudo: PacientesPage(
                            app: widget.app, grupoKey: grupo['key']))));
          },
        ),
      ));
    });
    return lista;
  }

  Widget getDrawer() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Editar perfil'),
          leading: Icon(Icons.assignment_ind),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BaseWindow(conteudo: PerfilPage(app: widget.app))));
          },
        ),
        ListTile(
            title: Text('Contatos'),
            leading: Icon(Icons.contacts),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BaseWindow(conteudo: ContatosPage(app: widget.app))));
            }),
        ListTile(
          title: Text('Configurações'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BaseWindow(
                        conteudo: ConfiguracoesPage(app: widget.app))));
          },
        ),
        ListTile(
          title: Text('Seja Premium!'),
          leading: Icon(Icons.monetization_on),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BaseWindow(conteudo: PremiumPage(app: widget.app))));
          },
        ),
        ListTile(
          title: Text('Sair'),
          leading: Icon(Icons.cancel),
          onTap: () {
            Usuarios.deslogar().then((r) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginPage(app: widget.app);
              }));
            });
          },
        )
      ],
    );
  }

  Widget getBody() {
    var lista = ListView(
      children: _gruposCards(),
    );
    return lista;
  }

  Future<Map<String, dynamic>> popCriaGrupo() async {
    return await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
            child: new SimpleDialog(
              title: const Text('Grupo'),
              children: <Widget>[
                new Container(
                  width: Tela.de(context).x(400.0),
                  height: Tela.de(context).y(10.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Tela.de(context).x(20.0)),
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          controller: _grupoNome,
                          decoration: InputDecoration(hintText: 'Nome'),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Tela.de(context).x(20.0)),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(20.0),
                        Tela.de(context).y(20.0),
                        Tela.de(context).x(20.0),
                        Tela.de(context).y(20.0)),
                    elevation: 1.0,
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context, new Grupo(nome: _grupoNome.text));
                    },
                    child: Text(
                      'Criar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _criaGrupo() async {
    await popCriaGrupo().then((Map<String, dynamic> grupo) {
      if (grupo != null) {
        setState(() {
          // Banco.colecao('grupos').add(grupo);
          // _grupoNome.text = '';
        });
      }
    });
  }

  void _validarUsuario() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser usuario) {
      if (usuario == null) {
        Navigator.pushNamed(context, LoginPage.tag);
      }
    });
  }

  void checarUsuario() {
    Usuario eu = Usuario.logado();
    Usuario.carregar().catchError((erro) {
      print(erro);
    }).then((evento) {
      eu = Usuario.logado();
      if (eu != null) {
        if (eu.idResidente == null || eu.idResidente == "") {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return BaseWindow(
                conteudo: PerfilPage(
              app: widget.app,
            ));
          }));
        }
      } else {
        if (Usuario.logado() != null) {
          Future.delayed(Duration(seconds: 1)).then((evento) {
            print('Não encontrou chave do usuário. Tentando de novo...');
            checarUsuario();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: Tela.de(context).y(20.0)),
          child: new Text('Resident'),
        ),
      ),
      body: new ListView(
        children: _gruposCards(),
      ),
      drawer: Drawer(
        child: getDrawer(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new BaseWindow(
              conteudo: DadosGrupoPage(),
            );
          }));
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
