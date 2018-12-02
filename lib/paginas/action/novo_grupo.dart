import 'package:resident/imports.dart';

//Classe que mostra as coisas
class DadosGrupoPage extends StatefulWidget {
  final String grupoChave;
  DadosGrupoPage({this.grupoChave = ''});

  @override
  State<StatefulWidget> createState() {
    return _DadosGrupoPageState();
  }
}

//Classe que controla a classe que mostra as coisas (Principal)
class _DadosGrupoPageState extends State<DadosGrupoPage> {
  String titulo = 'Novo grupo';
  TextEditingController _nomeDoGrupo = TextEditingController(text: '');
  TextEditingController _descricao = TextEditingController(text: '');
  FocusNode _focusNome;
  FocusNode _focusDescricao;
  Map<dynamic, dynamic> grupo;
  List _contatos;

  @override
  void initState() {
    super.initState();
    grupo = Map();
    carregaFocos();

    if (widget.grupoChave == null || widget.grupoChave == '')
      grupo = {
        'nome': '',
        'descricao': '',
        'contatos': [Usuario.eu['uid']]
      };
    else {
      carregarGrupo().then((event) {
        setState(() {
          titulo = grupo['nome'];
          _nomeDoGrupo.text = grupo['nome'];
          _descricao.text = grupo['descricao'];
          _contatos = grupo['contatos'];
        });
      });
    }
    _nomeDoGrupo.text = grupo['nome'];
    _descricao.text = grupo['descricao'];
    _contatos = grupo['contatos'];
  }

  void carregaFocos() {
    _focusNome = FocusNode();
    _focusNome.addListener(() {
      salvaTela();
    });
    _focusDescricao = FocusNode();
    _focusDescricao.addListener(() {
      salvaTela();
    });
  }

  void salvaTela() {
    setState(() {
      grupo['nome'] = _nomeDoGrupo.text;
      grupo['descricao'] = _descricao.text;
      grupo['contatos'] = _contatos;
    });
  }

  @override
  void dispose() {
    _focusNome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: _getAcoes(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: Tela.de(context).y(10.0)),
          FloatingActionButton(
            child: Icon(Icons.done_outline),
            onPressed: () {
              setState(() {
                salvaTela();
                titulo = grupo['nome'];
                salvarGrupo().then((snap) {
                  Navigator.pop(context);
                });
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: Tela.de(context).y(20.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(50.0)),
            child: TextFormField(
              controller: _nomeDoGrupo,
              focusNode: _focusNome,
              maxLength: 40,
              decoration: InputDecoration(
                  labelText: 'Nome do grupo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Tela.de(context).abs(20.0))))),
            ),
          ),
          SizedBox(height: Tela.de(context).y(20.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(50.0)),
            child: TextFormField(
              maxLength: 240,
              maxLines: 10,
              controller: _descricao,
              decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
          ),
          SizedBox(height: Tela.de(context).y(20.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(20.0)),
            child: SizedBox(
              height: Tela.de(context).y(300.0),
              child: Container(
                child: ListView(children: _contatosWidgets()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Null> carregarGrupo() async {
    await Firestore.instance
        .document('grupos/${widget.grupoChave}')
        .snapshots()
        .first
        .then((snap) {
      grupo = snap.data;
      if (grupo['contatos'] == null) grupo['contatos'] = [];
      grupo['key'] = snap.documentID;
    });
  }

  Future<Null> salvarGrupo() async {
    DocumentReference ref;
    if (grupo['key'] == null) {
      ref = Firestore.instance.collection('grupos').document();
    } else {
      ref = Firestore.instance.document('grupos/${grupo["key"]}');
    }
    await Firestore.instance.runTransaction((Transaction t) async {
      var snap = await t.get(ref);
      if (snap.exists) {
        await t.update(ref, grupo);
      } else {
        await t.set(ref, grupo);
      }
    }).catchError((erro) {
      print('deu ruim: $erro');
    });
    return null;
  }

  List<Widget> _contatosWidgets() {
    List<Widget> contatosWidgets = [];
    if (grupo != null && grupo['contatos'] != null) {
      contatosWidgets.add(SizedBox(
        height: Tela.de(context).y(50.0),
        child: MaterialButton(
          child: Text(
            '+ Add contato',
            style: TextStyle(fontSize: Tela.de(context).abs(25.0)),
          ),
          onPressed: () {
            salvaTela();
            abrirSelecaoContatos();
          },
        ),
      ));
      grupo['contatos'].forEach((contato) {
        Map<String, dynamic> contatoBanco = Banco.findUsuario(contato);
        if (contatoBanco != null) {
          contatosWidgets.add(Card(
            child: ListTile(
              title: Text(contatoBanco['nome']),
              contentPadding: EdgeInsets.all(Tela.de(context).abs(10.0)),
              trailing: contato == Usuario.eu['uid']
                  ? null
                  : _botaoRemover(contatoBanco),
              leading: CircleAvatar(
                child: Image.network(contatoBanco['urlFoto']),
              ),
            ),
          ));
        }
      });
    }

    return contatosWidgets;
  }

  List<Widget> _getAcoes() {
    List<Widget> lista = [];
    if (grupo['key'] != null) {
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
                  child: Text('Deseja sair do grupo ${grupo["nome"]}?'),
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
                          vertical: Tela.de(context).y(10.0)),
                      child: Text('Não'),
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'nao');
                    },
                  ),
                  SimpleDialogOption(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Tela.de(context).x(10.0),
                          vertical: Tela.de(context).y(10.0)),
                      child: Container(
                        color: Colors.redAccent,
                        child: Text('Sim'),
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
              _contatos = [];
              grupo['contatos'].forEach((cont) {
                if (cont != Usuario.eu['uid']) _contatos.add(cont);
              });
              salvaTela();
              salvarGrupo().then((snap) {
                Navigator.pop(context);
              });
            });
          }
        },
      ));
    }
    return lista;
  }

  Widget _botaoRemover(Map contatoBanco) {
    return IconButton(
      iconSize: Tela.de(context).abs(40.0),
      icon: Icon(
        Icons.remove_circle,
        color: Colors.redAccent,
      ),
      onPressed: () async {
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Deseja remover ${contatoBanco['nome']}?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Sim'),
                      onPressed: () {
                        Navigator.pop(context, 'sim');
                      },
                    ),
                    FlatButton(
                      child: Text('Não'),
                      onPressed: () {
                        Navigator.pop(context, 'nao');
                      },
                    )
                  ],
                );
              }).then((opcao) {
            if (opcao != null && opcao == 'sim') {
              setState(() {
                _contatos = [];
                _contatos.addAll(grupo['contatos']);
                _contatos.remove(contatoBanco['uid']);
                grupo['contato'] = _contatos;
              });
            }
          });
        });
      },
    );
  }

  Future<List<Usuario>> listaContatos() async {
    double h, v;
    h = Tela.de(context).x(25.0);
    v = Tela.de(context).x(25.0);
    return showDialog<List<Usuario>>(
        context: context,
        builder: (context) {
          List<Usuario> lista = [];
          return Padding(
            padding: EdgeInsets.fromLTRB(h, v, h, v),
            child: Center(
              child: Container(
                color: Colors.amberAccent,
                child: ListView(
                  children: <Widget>[],
                ),
              ),
            ),
          );
        });
  }

  Future<Null> abrirSelecaoContatos() async {
    List lista = grupo['contatos'];
    print(grupo);
    var _selecionados = await showDialog(
        context: context,
        builder: (context) {
          return ContatosGrupo(lista: lista);
        });

    setState(() {
      salvaTela();
      if (_selecionados != null) {
        _contatos = [];
        if (grupo['contatos'] == null)
          grupo['contatos'] = _contatos;
        else {
          grupo['contatos'].forEach((cont) {
            if (cont != null) _contatos.add(cont);
          });
        }
        _selecionados.forEach((String contato) {
          if (!_contatos.contains(contato)) _contatos.add(contato);
        });
        grupo['contatos'] = _contatos;
      }
      var grupoId = Banco.atualizarGrupo(grupo['key'],
          nome: grupo['nome'],
          descricao: grupo['descricao'],
          contatos: grupo['contatos']);
      grupo['key'] = grupoId;
    });
  }
}

class ContatosGrupo extends StatefulWidget {
  final List lista;
  ContatosGrupo({this.lista});
  _ContatosGrupoState createState() => _ContatosGrupoState();
}

class ContatoCard {
  String nome;
  bool adicionado = false;
  ContatoCard({this.nome, this.adicionado});
}

class _ContatosGrupoState extends State<ContatosGrupo> {
  List contatos = [];
  List<String> selecionados = [];
  List<Widget> contatosWidgets = [];
  List<ContatoCard> contatosCards = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> contsCards() {
    List<Widget> _lista = [];
    if (Usuario.eu['contatos'] != null) {
      Usuario.eu['contatos'].forEach((cont) {
        Map contato = Banco.findUsuario(cont);
        _lista.add(Card(
          child: ListTile(
            title: Text(contato['nome']),
            trailing: Checkbox(
              value: selecionados.contains(cont),
              onChanged: (bool marcado) {
                List<String> _conts = [];
                _conts.addAll(selecionados);
                if (marcado && !selecionados.contains(cont)) {
                  _conts.add(contato['uid']);
                } else if (!marcado && selecionados.contains(cont)) {
                  _conts.remove(contato['uid']);
                }
                setState(() {
                  selecionados = _conts;
                });
              },
            ),
          ),
        ));
      });
    }
    return _lista;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Tela.de(context).x(50.0),
          vertical: Tela.de(context).y(120.0)),
      child: Container(
        color: Colors.white,
        child: Column(children: [
          Expanded(
              child: Container(
            child: ListView(
              children: contsCards(),
            ),
          )),
          SizedBox(
            height: Tela.de(context).y(50.0),
            child: FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () {
                Navigator.pop(context, selecionados);
              },
            ),
          )
        ]),
      ),
    );
  }
}
