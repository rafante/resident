import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resident/entidades/paciente_class.dart';
import 'package:resident/paginas/base.dart';
import 'package:resident/paginas/paciente.dart';
import 'package:resident/paginas/paciente_detalhe.dart';
import 'package:resident/utilitarios/shared_prefs.dart';

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
      if (pacientes != null && pacientes.length > 0) {
        pacientes.forEach((chave, valor) {
          lista.add(new Paciente(
              key: chave,
              grupoKey: widget.grupoKey,
              entrada: DateTime.fromMillisecondsSinceEpoch(valor['entrada']),
              nome: valor['nome'],
              telefone: valor['telefone']));
        });
      }

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

  void _criaPaciente() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BaseWindow(
        conteudo: PacienteDetalhe(grupoKey: widget.grupoKey, pacienteKey: null),
      );
    }));
    // await _popupCriaPaciente().then((Paciente paciente) {
    //   DatabaseReference db = FirebaseDatabase.instance.reference();
    //   db = db.child('grupos').child(widget.grupoKey).child('pacientes');
    //   String chave = db.push().key;
    //   db.child(chave).child('nome').set(paciente.nome);
    //   paciente.key = chave;
    //   setState(() {
    //     _pacientes.add(paciente);
    //   });
    // });
  }

  List<Card> _pacientesCard() {
    List<Card> lista = <Card>[];
    _pacientes.forEach((Paciente paciente) {
      Prefs.checarNotificacoes(grupo: paciente.grupoKey, paciente: paciente.key)
          .then((int nots) {
        if (nots != paciente.notificacoes) {
          setState(() {
            paciente.notificacoes = nots;
          });
        }
      });
      lista.add(new Card(
        elevation: 2.0,
        child: ListTile(
            contentPadding: EdgeInsets.all(20.0),
            trailing: paciente.notificacoes == 0
                ? null
                : Stack(
                    children: <Widget>[
                      new Icon(Icons.airline_seat_flat_angled),
                      Positioned(
                        width: 13.0,
                        height: 15.0,
                        left: 10.0,
                        child: ClipOval(
                          child: Container(
                            color: Colors.amberAccent,
                            child: Center(
                              child: Text(paciente.notificacoes.toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            title: new Text(paciente.nome),
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BaseWindow(
                                conteudo: PacientePage(
                              app: widget.app,
                              paciente: paciente,
                              grupoKey: widget.grupoKey,
                              pacienteKey: paciente.key,
                            ))));
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
        title: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Title(
              color: Colors.lightBlueAccent, child: new Text('Pacientes')),
        ),
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
