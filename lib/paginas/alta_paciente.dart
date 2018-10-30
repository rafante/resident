import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AltaPacientePage extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;

  static String tag = 'alta-paciente';
  AltaPacientePage({this.app, this.pacienteKey, this.grupoKey});
  _AltaPacientePageState createState() => _AltaPacientePageState();
}

class _AltaPacientePageState extends State<AltaPacientePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alta do Paciente')),
    );
  }
}
