import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resident/mensagem.dart';
import 'package:resident/paciente_class.dart';

class PacientePage extends StatefulWidget {
  static String tag = 'paciente-page';
  final Paciente paciente;
  final FirebaseApp app;
  final String pacienteKey;
  PacientePage({this.app, this.paciente, this.pacienteKey});
  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  List<Mensagem> _mensagens = <Mensagem>[];

  TextEditingController _textController = TextEditingController(text: '');
  bool _isWriting;

  @override
  void initState() {
    DatabaseReference db = FirebaseDatabase.instance.reference();
    db
        .child('pacientes')
        .child(widget.pacienteKey)
        .child('chat')
        .onValue
        .listen((Event evento) {
          // Map mensagens = 
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.purpleAccent,
          title: new Text(widget.paciente.nome)),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, int indice) => _mensagens[indice],
              itemCount: _mensagens.length,
              reverse: true,
              padding: EdgeInsets.all(10.0),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            child: _construirComposer(),
            decoration: BoxDecoration(color: Colors.purpleAccent),
          )
        ],
      ),
      endDrawer: Drawer(
        elevation: 1.0,
        child: ListView(
          children: <Widget>[
            new ListTile(
                title: Text('Teste'),
                dense: true,
                subtitle: Text('abc'),
                enabled: true,
                isThreeLine: true,
                onTap: () {},
                leading: Icon(Icons.accessibility),
                contentPadding: EdgeInsets.all(10.0),
                trailing: Icon(Icons.access_alarm))
          ],
        ),
      ),
    );
  }

  Widget _construirComposer() {
    return IconTheme(
      data: new IconThemeData(color: Colors.purpleAccent),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 29.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: TextField(
                  controller: _textController,
                  onChanged: (String textoDigitado) {
                    setState(() {
                      _isWriting = textoDigitado.length > 0;
                    });
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: 'Digite aqui')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              child: IconButton(
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                onPressed: () {
                  Mensagem mensagem = new Mensagem(
                      texto: _textController.text, hora: DateTime.now());
                  _textController.text = '';
                  setState(() {
                    _mensagens.add(mensagem);
                    _mensagens = _mensagens.reversed.toList();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
