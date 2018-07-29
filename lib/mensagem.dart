import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mensagem extends StatelessWidget {
  final String autor;
  final String texto;
  final DateTime hora;

  Mensagem({this.autor, this.texto, this.hora});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(texto),
      subtitle: Text(new DateFormat('dd/MM/yyyy  HH:mm:ss').format(hora)),
    ));
  }
}
