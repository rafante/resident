import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resident/paciente.dart';
import 'package:resident/paciente_class.dart';

class PacientesPage extends StatefulWidget {
  static String tag = 'pacientes-page';
  final String grupoKey;
  final FirebaseApp app;
  PacientesPage({this.app, this.grupoKey});

  @override
  _PacientesPageState createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  TextEditingController _pacienteNome = TextEditingController(text: '');

  @override
  void initState() {
    DatabaseReference db = FirebaseDatabase.instance.reference();
    db
        .child('grupos')
        .child(widget.grupoKey)
        .child('pacientes')
        .onValue
        .listen((Event evento) {
      Map pacientes = evento.snapshot.value;
      List<Paciente> lista = <Paciente>[];
      pacientes.forEach((chave, valor) {
        lista.add(new Paciente(key: chave, nome: valor['nome']));
      });
      setState(() {
        _pacientes = lista;
      });
    });
    super.initState();
  }

  List<Paciente> _pacientes = <Paciente>[];

  Future<Paciente> _popupCriaPaciente() async {
    return await showDialog<Paciente>(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: SimpleDialog(
              title: Text('Paciente'),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 300.0,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _pacienteNome,
                        decoration: InputDecoration(hintText: 'Nome'),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Outro dado'),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 80.0),
                  color: Colors.blueAccent,
                  child: Text('Criar', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(
                        context, new Paciente(nome: _pacienteNome.text));
                  },
                )
              ],
            ),
          );
        });
  }

  void _criaPaciente() async {
    await _popupCriaPaciente().then((Paciente paciente) {
      DatabaseReference db = FirebaseDatabase.instance.reference();
      db = db.child('grupos').child(widget.grupoKey).child('pacientes');
      String chave = db.push().key;
      db.child(chave).child('nome').set(paciente.nome);
      paciente.key = chave;
      setState(() {
        _pacientes.add(paciente);
      });
    });
  }

  List<Card> _pacientesCard() {
    List<Card> lista = <Card>[];
    _pacientes.forEach((Paciente paciente) {
      lista.add(new Card(
        elevation: 2.0,
        child: ListTile(
            contentPadding: EdgeInsets.all(20.0),
            trailing: new Icon(Icons.airline_seat_flat_angled),
            title: new Text(paciente.nome),
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PacientePage(
                              app: widget.app,
                              paciente: paciente,
                              pacienteKey: paciente.key,
                            )));
              });
            }),
      ));
    });
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: new Icon(Icons.airline_seat_flat),
        elevation: 1.0,
        title: new Title(
            color: Colors.lightBlueAccent, child: new Text('Pacientes')),
      ),
      body: ListView(
        children: _pacientesCard(),
        itemExtent: 80.0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _criaPaciente();
        },
      ),
    );
  }
}
