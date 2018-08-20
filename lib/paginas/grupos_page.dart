import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resident/entidades/grupos_class.dart';
import 'package:resident/paginas/action/novo_grupo.dart';
import 'package:resident/paginas/base.dart';
import 'package:resident/paginas/criar_usuario_page.dart';
import 'package:resident/paginas/drawers/grupo/configuracoes.dart';
import 'package:resident/paginas/drawers/grupo/contatos.dart';
import 'package:resident/paginas/drawers/grupo/perfil.dart';
import 'package:resident/paginas/drawers/grupo/premium.dart';
import 'package:resident/paginas/pacientes.dart';

class GruposPage extends StatefulWidget {
  static String tag = 'home-page';
  GruposPage({Key key, this.title, this.app}) : super(key: key);
  final FirebaseApp app;
  final String title;

  @override
  _GruposPageState createState() => new _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  DatabaseReference db;

  List<Grupo> _grupos = <Grupo>[];
  TextEditingController _grupoNome = TextEditingController(text: '');

  List<Card> _gruposCards() {
    List<Card> lista = <Card>[];
    _grupos.forEach((Grupo grupo) {
      lista.add(new Card(
        child: new ListTile(
          trailing: new Icon(Icons.group),
          dense: true,
          contentPadding: EdgeInsets.all(20.0),
          title: new Text(grupo.nome),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BaseWindow(
                        conteudo: PacientesPage(
                            app: widget.app, grupoKey: grupo.key))));
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
            Navigator.pop(context);
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

  Future<Grupo> popCriaGrupo() async {
    return await showDialog<Grupo>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: new SimpleDialog(
              title: const Text('Grupo'),
              children: <Widget>[
                new Container(
                  width: 400.0,
                  height: 100.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10.0),
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
    await popCriaGrupo().then((Grupo grupo) {
      if (grupo != null) {
        String grupoChave = db.child('grupos').push().key;
        db.child('grupos').child(grupoChave).child('nome').set(grupo.nome);
        setState(() {
          _grupos.add(new Grupo(nome: grupo.nome, key: grupoChave));
          _grupoNome.text = '';
        });
      }
    });
  }

  void _validarUsuario() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser usuario) {
      if (usuario == null) {
        Navigator.pushNamed(context, CriarUsuarioPage.tag);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _validarUsuario();
    db = FirebaseDatabase.instance.reference();
    db.child('grupos').onValue.listen((Event evento) {
      List<Grupo> gruposLista = <Grupo>[];
      final Map<dynamic, dynamic> grupos = evento.snapshot.value;
      if (grupos != null) {
        grupos.forEach((chave, valor) {
          gruposLista.add(new Grupo(nome: valor['nome'], key: chave));
        });
      }
      setState(() {
        _grupos = gruposLista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 20.0),
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
            return new NovoGrupoPage(app: widget.app);
          }));
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
