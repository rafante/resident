import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resident/entidades/paciente_class.dart';

class HipoteseDiagnosticaPage extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;

  static String tag = 'hipotese-diagnostica';
  HipoteseDiagnosticaPage({this.app, this.pacienteKey, this.grupoKey});
  _HipoteseDiagnosticaPageState createState() =>
      _HipoteseDiagnosticaPageState();
}

class _HipoteseDiagnosticaPageState extends State<HipoteseDiagnosticaPage> {
  TextEditingController _hipoteseDiagnostica = TextEditingController(text: '');
  Paciente paciente;

  @override
  void initState() {
    paciente = new Paciente(key: widget.pacienteKey, grupoKey: widget.grupoKey);
    paciente.carregaDadosDoServidor(carregarDadosExtras: true).then((event) {
      _hipoteseDiagnostica.text = paciente.hipoteseDiagnostica;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('História Diagnostica')),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _hipoteseDiagnostica,
                maxLines: 18,
                maxLengthEnforced: true,
                onEditingComplete: () {
                  setState(() {
                    print(_hipoteseDiagnostica.text);
                  });
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Hipótese diagnóstica...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            paciente.salvarHipoteseDiagnostica(_hipoteseDiagnostica.text);
            paciente.salvar();
            Navigator.pop(context);
          },
        ));
  }
}
