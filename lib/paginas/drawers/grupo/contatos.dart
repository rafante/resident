import 'package:resident/imports.dart';

class ContatosPage extends StatefulWidget {
  final FirebaseApp app;
  ContatosPage({this.app});
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  List _contatos = [];

  @override
  void initState() {
    _contatos = Usuario.eu['contatos'];
    super.initState();
  }

  List<Widget> _contatosWidgets() {
    List<Widget> widgets = [];
    _contatos.forEach((cont) {
      var usuario = Banco.findUsuario(cont);
      if (usuario != null) {
        widgets.add(Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(usuario['urlFoto']),
            ),
            title: Text(usuario['nome']),
            subtitle: Text(usuario['email']),
          ),
        ));
      }
    });
    return widgets;
  }

  Future<Usuario> adicionarContato() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Tela.de(context).x(50.0),
                vertical: Tela.de(context).y(100.0)),
            child: PopupContatos(),
          );
        });
    setState(() {
      _contatos = Usuario.eu['contatos'];
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Navegador.tagAtual = Tag.CONTATOS;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView(children: _contatosWidgets()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          adicionarContato();
        },
      ),
    );
  }
}

class PopupContatos extends StatefulWidget {
  _PopupContatosState createState() => _PopupContatosState();
}

class _PopupContatosState extends State<PopupContatos> {
  Map<String, dynamic> _usuario;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Tela.de(context).x(10.0),
                    Tela.de(context).y(10.0),
                    Tela.de(context).x(10.0),
                    Tela.de(context).y(10.0)),
                child: TextField(
                  onChanged: (valor) {
                    if (valor.length >= 3) {
                      if (valor != Usuario.eu['idResidente']) {
                        Usuario.lerResidente(valor).then((usuario) {
                          setState(() {
                            if (usuario != null) {
                              _usuario = usuario;
                            } else
                              _usuario = null;
                          });
                        }).catchError((erro) {
                          print(erro.toString());
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.fromLTRB(
                          Tela.de(context).x(10.0),
                          Tela.de(context).y(10.0),
                          Tela.de(context).x(10.0),
                          Tela.de(context).y(10.0)),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
            ),
            Card(
              child: _usuario != null
                  ? ListTile(
                      leading: Icon(Icons.person),
                      title: Text(_usuario['nome']),
                    )
                  : Container(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            if (_usuario != null) {
              Usuario.adicionarContato(_usuario['uid']);
              Usuario.salvar();
              setState(() {
                Navigator.pop(context);
              });
            }
          },
        ),
      ),
    );
  }
}
