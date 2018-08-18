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
    );
  }
}