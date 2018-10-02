import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resident/entidades/paciente_class.dart';
import 'package:resident/utilitarios/widgets.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PacienteDetalhe extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;

  PacienteDetalhe({this.app, this.pacienteKey});

  @override
  _PacienteDetalheState createState() => _PacienteDetalheState();
}

class _PacienteDetalheState extends State<PacienteDetalhe> {
  TextEditingController _nome = TextEditingController(text: '');
  TextEditingController _data = TextEditingController(text: '');

  DateFormat dateFormat = DateFormat("d, MMMM, yyyy 'at' h:mma");
  Paciente paciente;

  @override
  void initState() {
    super.initState();
    paciente = Paciente(key: widget.pacienteKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do paciente'),
      ),
      body: ListView(children: [
        //nome
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _nome,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Digite o nome',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: DateTimePickerFormField(
            controller: _nome,
            format: dateFormat,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Data de entrada',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        child: Icon(Icons.done_outline),
        onPressed: () {
          setState(() {
            // paciente.nome = nome.digitado;
            print('salvou o cliente');
          });

          paciente.salvar();
        },
      ),
    );
  }
}
