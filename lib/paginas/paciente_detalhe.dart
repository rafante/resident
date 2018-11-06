import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resident/entidades/paciente_class.dart';
import 'package:resident/utilitarios/widgets.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PacienteDetalhe extends StatefulWidget {
  final FirebaseApp app;
  final String grupoKey;
  final String pacienteKey;

  PacienteDetalhe({this.app, this.grupoKey, this.pacienteKey});

  @override
  _PacienteDetalheState createState() => _PacienteDetalheState();
}

class _PacienteDetalheState extends State<PacienteDetalhe> {
  TextEditingController _nome = TextEditingController(text: '');
  TextEditingController _data = TextEditingController(text: '');
  TextEditingController _telefone = TextEditingController(text: '');

  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm:ss");
  DateTime dataEntrada;
  Paciente paciente;

  @override
  void initState() {
    super.initState();
    paciente = Paciente(key: widget.pacienteKey, grupoKey: widget.grupoKey);
    paciente.carregaDadosDoServidor().then((evento) {
      setState(() {
        _nome.text = paciente.nome;
        _data.text = dateFormat.format(paciente.entrada);
        _telefone.text = paciente.telefone;
      });
    });
    print(paciente.grupoKey);
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
            onEditingComplete: () {
              setState(() {
                print(_nome.text);
                paciente.salvaNome(_nome.text);
              });
            },
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
            controller: _data,
            format: dateFormat,
            onChanged: (DateTime novaData) {
              setState(() {
                dataEntrada = novaData;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Data de entrada',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: _telefone,
            onEditingComplete: () {
              setState(() {
                print(_telefone.text);
                paciente.salvaTelefone(_telefone.text);
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Telefone',
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
            paciente.salvaNome(_nome.text);
            paciente.salvaEntrada(dataEntrada);
            paciente.salvaTelefone(_telefone.text);
            paciente.salvar();
            print('salvou o cliente');
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}
