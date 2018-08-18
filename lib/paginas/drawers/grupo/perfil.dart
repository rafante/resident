import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  final FirebaseApp app;
  PerfilPage({this.app});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
    );
  }
}
