import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resident/grupos_page.dart';
import 'package:resident/login_page.dart';
import 'package:resident/main.dart';

class CriarUsuarioPage extends StatefulWidget {
  static String tag = 'criar-usuario-page';
  final FirebaseApp app;

  CriarUsuarioPage({this.app});

  @override
  _CriarUsuarioPageState createState() => _CriarUsuarioPageState();
}

class _CriarUsuarioPageState extends State<CriarUsuarioPage> {
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _senha1 = TextEditingController(text: '');
  TextEditingController _senha2 = TextEditingController(text: '');
  bool _errado = false;
  int _exception;
  String _erroTxt;

  Text mensagemErro() {
    return Text(_erroTxt != null ? _erroTxt : '',
        style: TextStyle(
            fontSize: 20.0,
            color: _erroTxt != null ? Colors.redAccent : Colors.white));
  }

  Future<FirebaseUser> criarUsuario() async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _email.text, password: _senha1.text);
    return user;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Center(
            child: Text(
              'Criar Usuário',
              style: TextStyle(
                  // decoration: TextDecoration.underline,
                  // color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 40.0),
          Icon(Icons.account_circle, size: 120.0),
          SizedBox(height: 40.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Digite seu e-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: TextFormField(
              obscureText: true,
              controller: _senha1,
              decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  hintText: 'Digite sua senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: TextFormField(
              obscureText: true,
              decoration: new InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  hintText: 'Confirmar senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              controller: _senha2,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, .0, 10.0),
            child: Center(
              child: mensagemErro(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 20.0, 0.0),
            child: Material(
              // borderRadius: BorderRadius.circular(55.0),
              shadowColor: Colors.lightBlueAccent,
              elevation: 5.0,
              child: MaterialButton(
                height: 52.0,
                onPressed: () {
                  if (_senha1.text == _senha2.text) {
                    setState(() {
                      _erroTxt = '';
                    });
                  } else {
                    setState(() {
                      _erroTxt = 'As senhas não coincidem';
                    });
                    return;
                  }
                  criarUsuario().then((user) {
                    Navigator.of(context).pushNamed(GruposPage.tag);
                  }).catchError((erro) {
                    setState(() {
                      _erroTxt = 'Endereço de e-mail já existe';
                    });
                  });
                },
                color: Colors.black,
                child: Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 20.0, 0.0),
            child: Material(
              // borderRadius: BorderRadius.circular(55.0),
              shadowColor: Colors.lightBlueAccent,
              elevation: 5.0,
              child: MaterialButton(
                height: 52.0,
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginPage.tag);
                },
                color: Colors.blueAccent,
                child: Text(
                  'Logar',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              child: Text(
                'Esqueceu sua senha?',
                style: TextStyle(color: Colors.black54, fontSize: 18.0),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
