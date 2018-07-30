import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:resident/criar_usuario_page.dart';
import 'package:resident/grupos_page.dart';
import 'package:resident/login_page.dart';
import 'package:resident/paciente.dart';
import 'package:resident/pacientes.dart';
import 'package:resident/usuarios.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'resident',
    options: const FirebaseOptions(
      googleAppID: '1:371558675525:android:f3f9323fc4060503',
      apiKey: 'AIzaSyC9yvU5sn4h4W113fFtHbRdoPCFVAU_z9g',
      databaseURL: 'https://resident-cadu.firebaseio.com',
    ),
  );
  runApp(new MaterialApp(
    title: 'Resident',
    home: new MyApp(app: app),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.app});
  final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    Usuarios.logado();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
      title: 'Resident',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GruposPage(app: app),
      routes: <String, WidgetBuilder>{
        LoginPage.tag: (context) => LoginPage(app: app),
        GruposPage.tag: (context) => GruposPage(app: app),
        PacientesPage.tag: (context) => PacientesPage(app: app),
        PacientePage.tag: (context) => PacientePage(app: app),
        CriarUsuarioPage.tag: (context) => CriarUsuarioPage(app: app)
      },
    );
  }
}
