import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:resident/componentes/card_contato.dart';
import 'package:resident/entidades/banco.dart';
import 'package:resident/entidades/usuarios.dart';

class ContatosPage extends StatefulWidget {
  final FirebaseApp app;
  ContatosPage({this.app});
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  List<Usuario> _contatos = [];

  @override
  void initState() {
    _contatos = Usuario.logado().contatos;
    super.initState();
  }

  List<Widget> _contatosWidgets() {
    List<Widget> widgets = [];
    _contatos.forEach((Usuario usuario) {
      widgets.add(Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(usuario.urlFoto),
          ),
          title: Text(usuario.nome),
          subtitle: Text(usuario.email),
        ),
      ));
    });
    return widgets;
  }

  Future<Usuario> adicionarContato() async {
    String chaveContato = "";
    String nomeContato = "";
    String idResidente = "";

    await showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
            child: Scaffold(
              body: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextField(
                        onChanged: (valor) {
                          if (valor.length >= 3) {
                            Banco.ref()
                                .child('usuarios')
                                .child('ids')
                                .child(valor)
                                .once()
                                .then((snap) {
                              if (snap.value != null) {
                                Banco.ref()
                                    .child('usuarios')
                                    .child(snap.value)
                                    .once()
                                    .then((snap) {
                                  setState(() {
                                    nomeContato = snap.value['displayName'];
                                    chaveContato = snap.key;
                                    idResidente = snap.value['idResidente'];
                                  });
                                });
                              }
                            });
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                  ),
                  Card(
                    child: nomeContato != ""
                        ? ListTile(
                            leading: Icon(Icons.person),
                            title: Text(nomeContato),
                          )
                        : Container(),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.done),
                onPressed: () {
                  Usuario.adicionarContato(chaveContato).then((evento) {
                    setState(() {
                      Navigator.pop(context);
                    });
                  });
                },
              ),
            ),
          );
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView(
        children: _contatosWidgets(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          adicionarContato();
        },
      ),
    );
  }
}
