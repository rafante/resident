import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resident/entidades/usuarios.dart';
import 'package:resident/paginas/grupos_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final FirebaseApp app;
  LoginPage({this.app});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logo = new Icon(Icons.account_circle, size: 120.0, color: Colors.black);
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _senha = TextEditingController(text: '');
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  String _erroMsg;

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    print("Username: ${user.displayName}");
    return user;
  }

  static Future<String> _testSignInAnonymously() async {
    final FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      // assert(user.providerData.length == 1);
      // assert(user.providerData[0].providerId == 'firebase');
      // assert(user.providerData[0].uid != null);
      // assert(user.providerData[0].displayName == null);
      // assert(user.providerData[0].photoUrl == null);
      // assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInAnonymously succeeded: $user';
  }

  Future<FirebaseUser> _loginEmail() async {
    FirebaseUser usuario = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email.text, password: _senha.text);
    Usuarios.setLogado(usuario);
    return usuario;
  }

  final esqueceuSenhaLbl = FlatButton(
    child: Text(
      'Esqueceu sua senha?',
      style: TextStyle(color: Colors.black54),
    ),
    onPressed: () {},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              controller: _email,
              decoration: InputDecoration(
                  hintText: 'Email',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(height: 24.0),
            TextFormField(
              autofocus: false,
              obscureText: true,
              controller: _senha,
              decoration: InputDecoration(
                  hintText: 'Senha',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(height: 48.0),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _erroMsg != null ? _erroMsg : '',
                  style: TextStyle(color: Colors.redAccent),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 52.0,
                  onPressed: () {
                    _signIn().then((user) {
                      Fluttertoast.showToast(
                          msg: "Usuario ${user.displayName} logado",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          bgcolor: "#e74c3c",
                          textcolor: '#ffffff');

                      Navigator.of(context).pushNamed(GruposPage.tag);
                      Usuarios.setLogado(user);
                      
                    }).catchError((erro) {
                      print(erro.toString());
                    });
                    // _loginEmail().then((FirebaseUser usuario) {
                    //   Navigator.of(context).pushNamed(GruposPage.tag);
                    // }).catchError((erro) {
                    //   setState(() {
                    //     _erroMsg = erro.message;
                    //   });
                    // });
                  },
                  color: Colors.blueAccent,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            esqueceuSenhaLbl
          ],
        ),
      ),
    );
  }
}
