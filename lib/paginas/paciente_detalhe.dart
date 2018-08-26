
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resident/entidades/paciente_class.dart';

class PacienteDetalhe extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;

  PacienteDetalhe({this.app, this.pacienteKey});

  @override
  _PacienteDetalheState createState() => _PacienteDetalheState();
}

class _PacienteDetalheState extends State<PacienteDetalhe> {

  @override
  void initState(){
    super.initState();
    Paciente paciente = Paciente(key: widget.pacienteKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}