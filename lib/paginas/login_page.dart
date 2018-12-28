import 'package:resident/imports.dart';

class LoginPage extends StatefulWidget {
  static const String tag = 'login-page';
  final FirebaseApp app;
  LoginPage({this.app});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final logo = new Icon(Icons.account_circle, size: 120.0, color: Colors.black);
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _senha = TextEditingController(text: '');
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    FirebaseUser user;
    GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signIn().then((signin) async {
      if (signin != null) {
        GoogleSignInAuthentication authentication = await signin.authentication;
        user = await FirebaseAuth.instance.signInWithGoogle(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);
      }
    }).catchError((erro) {
      erro = true;
    });

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
    Usuario.setLogado(context, usuario);
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
    Navegador.tagAtual = Tag.LOGIN;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          child: _lista(),
        ),
      ),
    );
  }

  Widget _lista() {
    return Padding(
      padding: EdgeInsets.only(
          left: Tela.de(context).x(20.0),
          right: Tela.de(context).y(20.0),
          top: Tela.de(context).y(120.0)),
      child: _componentesLogin(),
    );
  }

  Widget _componentesLogin() {
    return Column(
      // shrinkWrap: true,

      children: <Widget>[
        Image.asset(
          'images/ic_launcher.png',
          width: Tela.de(context).x(180.0),
          height: Tela.de(context).y(180.0),
        ),
        SizedBox(height: 140.0),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Tela.de(context).x(16.0),
              horizontal: Tela.de(context).y(8.0)),
          child: Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.lightBlueAccent,
            // elevation: 5.0,
            child: MaterialButton(
              minWidth: Tela.de(context).x(80.0),
              height: Tela.de(context).y(52.0),
              elevation: 4.0,
              onPressed: () {
                _signIn().then((user) {
                  if (user != null) {
                    Usuario.setLogado(context, user).then((evento) {
                      // Fluttertoast.showToast(
                      //     msg: "Usuario ${user.displayName} logado",
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.BOTTOM,
                      //     timeInSecForIos: 1, 
                      //     bgcolor: "#e74c3c",
                      //     textcolor: '#ffffff');
                    });
                  }
                });
              },
              color: Colors.redAccent,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(FontAwesomeIcons.google, color: Colors.white),
                    width: Tela.de(context).x(40.0),
                    height: Tela.de(context).y(40.0),
                    // color: Colors.tealAccent,
                  ),
                  SizedBox(width: Tela.de(context).x(20.0)),
                  Center(
                    child: Text(
                      'Login com Google',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Tela.de(context).abs(25.0)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // esqueceuSenhaLbl
      ],
    );
  }
}
