import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  final FirebaseApp app;
  ConfiguracoesPage({this.app});
  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configurações'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 0.0),
                child: Center(
                    child: Text(
                  'Alteração de senha',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(border: Border.all(width: 1.0)),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      child: ListView(
                        children: <Widget>[
                          FormField(
                            builder: (context) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Senha atual',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FormField(
                            builder: (context) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Nova senha',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              );
                            },
                          ),
                          SizedBox(height: 10.0),
                          FormField(
                            builder: (context) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Confirmação da senha',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }
}
