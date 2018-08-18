
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ContatosPage extends StatefulWidget {
  final FirebaseApp app;
  ContatosPage({this.app});
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
    );
  }
}