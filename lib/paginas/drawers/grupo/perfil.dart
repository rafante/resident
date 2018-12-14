import 'package:resident/imports.dart';

class PerfilPage extends StatefulWidget {
  final FirebaseApp app;
  static String tag = 'perfil';
  PerfilPage({this.app});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  TextEditingController _nome = TextEditingController(text: '');
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _telefone = TextEditingController(text: '');
  TextEditingController _idResidente = TextEditingController(text: '');

  @override
  void initState() {
    if (Usuario.estaLogado()) {
      setState(() {
        _nome.text = Usuario.eu['nome'];
        _email.text = Usuario.eu['email'];
        _telefone.text = Usuario.eu['telefone'];
        _idResidente.text = Usuario.eu['idResidente'];
      });
    }
    super.initState();
  }

  void _validarUsuario() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser usuario) {
      if (usuario == null) {
        Navegador.de(context).navegar(Tag.LOGIN, null);
      }
    });
  }

  void salvar() {
    setState(() {
      Usuario.eu['nome'] = _nome.text;
      Usuario.eu['email'] = _email.text;
      Usuario.eu['telefone'] = _telefone.text;
      if (_idResidente.text != Usuario.eu['idResidente']) {
        Usuario.buscarId(_idResidente.text).then((user) {
          if (user == null) {
            Usuario.eu['idResidente'] = _idResidente.text;
            Usuario.salvar();
            // await Fluttertoast.showToast(
            //     msg: "Usuario salvo",
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.BOTTOM,
            //     timeInSecForIos: 1,
            //     bgcolor: "#e74c3c",
            //     textcolor: '#ffffff');
            Navegador.de(context).navegar(Tag.GRUPOS, null);
          } else {
            Fluttertoast.showToast(
                msg: "Esse usuário já existe",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                bgcolor: "#e74c3c",
                textcolor: '#ffffff');
          }
        });
      } else {
        Usuario.eu['idResidente'] = _idResidente.text;
        Usuario.salvar();
        Fluttertoast.showToast(
                msg: "Usuario salvo",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                bgcolor: "#e74c3c",
                textcolor: '#ffffff')
            .then((mensagem) {
          Navegador.de(context).navegar(Tag.GRUPOS, null);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Usuario.eu['idResidente'] != _idResidente.text) {
          if (_nome.text != '') {
            salvar();
          }
        }
        if (Usuario.eu['idResidente'] == null ||
            Usuario.eu['idResidente'] == "") {
          Fluttertoast.showToast(
              msg: "Para prosseguir favor inserir um nome de usuário válido",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              bgcolor: "#e74c3c",
              textcolor: '#ffffff');
          return false;
        }
        if (Usuario.eu['telefone'] == null || Usuario.eu['telefone'] == "") {
          Fluttertoast.showToast(
              msg: "Obrigatório preenchimento do telefone",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              bgcolor: "#e74c3c",
              textcolor: '#ffffff');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            salvar();
          },
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: Tela.de(context).y(30.0)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
              child: SizedBox(
                height: Tela.de(context).y(150.0),
                child: CachedNetworkImage(
                  imageUrl: Usuario.eu != null ? Usuario.eu['urlFoto'] : "",
                ),
              ),
            ),
            // SizedBox(height: Tela.de(context).y(30.0)),
            Center(
                child: Text('Alterar imagem',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Tela.de(context).abs(20.0)))),
            SizedBox(height: Tela.de(context).y(30.0)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
              child: TextFormField(
                controller: _idResidente,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontSize: Tela.de(context).abs(20.0), color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0),
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0)),
                    labelText: 'Nome de usuário',
                    labelStyle: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: Tela.de(context).x(10.0)))),
              ),
            ),
            SizedBox(height: Tela.de(context).y(30.0)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
              child: TextFormField(
                controller: _nome,
                style: TextStyle(
                    fontSize: Tela.de(context).abs(20.0), color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0),
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0)),
                    labelText: 'Nome',
                    labelStyle: TextStyle(fontSize: Tela.de(context).y(20.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: Tela.de(context).x(1.0)))),
              ),
            ),
            SizedBox(height: Tela.de(context).y(30.0)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
              child: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontSize: Tela.de(context).abs(20.0), color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0),
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0)),
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: Tela.de(context).x(1.0)))),
              ),
            ),
            SizedBox(height: Tela.de(context).y(30.0)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Tela.de(context).x(30.0)),
              child: TextFormField(
                controller: _telefone,
                style: TextStyle(
                    fontSize: Tela.de(context).abs(20.0), color: Colors.black),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        Tela.de(context).y(10.0),
                        Tela.de(context).y(10.0),
                        Tela.de(context).y(10.0),
                        Tela.de(context).y(10.0)),
                    labelText: 'Telefone',
                    labelStyle: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: Tela.de(context).x(1.0)))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
