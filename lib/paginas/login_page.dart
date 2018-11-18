import 'package:resident/imports.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
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
    Usuario.setLogado(usuario);
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
          padding: EdgeInsets.only(
              left: Tela.de(context).x(24.0), right: Tela.de(context).y(24.0)),
          children: <Widget>[
            Image.asset('images/icone.png',
                width: Tela.de(context).x(180.0),
                height: Tela.de(context).y(180.0)),
            SizedBox(height: 140.0),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Tela.de(context).x(16.0),
                  horizontal: Tela.de(context).y(16.0)),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent,
                // elevation: 5.0,
                child: MaterialButton(
                  minWidth: Tela.de(context).x(200.0),
                  height: Tela.de(context).y(52.0),
                  elevation: 4.0,
                  onPressed: () {
                    _signIn().then((user) {
                      Usuario.setLogado(user);
                      Fluttertoast.showToast(
                              msg: "Usuario ${user.displayName} logado",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              bgcolor: "#e74c3c",
                              textcolor: '#ffffff')
                          .then((evento) {
                            Navigator.of(context).pushNamed(GruposPage.tag);
                          });
                    });
                  },
                  color: Colors.redAccent,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child:
                            Icon(FontAwesomeIcons.google, color: Colors.white),
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
        ),
      ),
    );
  }
}
