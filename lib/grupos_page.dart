import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resident/criar_usuario_page.dart';
import 'package:resident/grupos_class.dart';
import 'package:resident/pacientes.dart';

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
                    builder: (context) =>
                        PacientesPage(app: widget.app, grupoKey: grupo.key)));
          },
        ),
      ));
    });
    return lista;
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Resident'),
      ),
      body: new ListView(
        children: _gruposCards(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _criaGrupo,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
