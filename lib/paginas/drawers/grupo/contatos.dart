import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:resident/entidades/contato.dart';

class ContatosPage extends StatefulWidget {
  final FirebaseApp app;
  ContatosPage({this.app});
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  List<Contato> _contatos;

  List<Widget> _getContatosWidgets() {
    List<Widget> widgets = [];
    _contatos.forEach((Contato contato) {
      widgets.add(new Card(
        child: ListTile(
          leading: ClipOval(
            child: Image.memory(contato.avatar),
          ),
          title: Text(contato.nome ?? ""),
          subtitle: Text(contato.numero ?? ""),
        ),
      ));
    });
    return widgets;
  }

  Future<void> _obterContatos() async {
    Iterable<Contact> contatos;
    await ContactsService.getContacts().then((Iterable<Contact> qConts) {
      contatos = qConts;
    });
    List<Contato> conts = [];

    contatos.toList().forEach((Contact contato) {
      List telefones = contato.phones.toList();
      String telefone = "";
      String nome = "";
      Uint8List avatar;
      if (telefones.length > 0) telefone = telefones.first.value;
      if (contato.avatar != null) avatar = contato.avatar;
      if (contato.givenName != null) nome = contato.givenName;
      if (contato.displayName != null) nome = contato.displayName;
      Contato cont = new Contato(nome: nome, numero: telefone, avatar: avatar);
      conts.add(cont);
    });
    setState(() {
      _contatos = conts;
    });
  }

  @override
  void initState() {
    super.initState();
    _contatos = [];
    _obterContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView(
        children: _getContatosWidgets(),
      ),
    );
  }
}
