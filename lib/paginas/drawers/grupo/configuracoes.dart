import 'package:resident/imports.dart';

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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(
                  Tela.de(context).x(20.0),
                  Tela.de(context).y(120.0),
                  Tela.de(context).x(20.0),
                  Tela.de(context).y(0.0),
                ),
                child: Center(
                    child: Text(
                  'Alteração de senha',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Tela.de(context).x(20.0),
                  Tela.de(context).y(10.0),
                  Tela.de(context).x(20.0),
                  Tela.de(context).y(0.0)),
              child: Container(
                  height: Tela.de(context).y(150.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: Tela.de(context).x(1.0))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0),
                        Tela.de(context).x(10.0),
                        Tela.de(context).y(10.0)),
                    child: Form(
                      child: ListView(
                        children: <Widget>[
                          FormField(
                            builder: (context2) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Senha atual',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        Tela.de(context).x(10.0),
                                        Tela.de(context).y(10.0),
                                        Tela.de(context).x(10.0),
                                        Tela.de(context).y(10.0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FormField(
                            builder: (context3) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Nova senha',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        Tela.de(context).x(10.0),
                                        Tela.de(context).y(10.0),
                                        Tela.de(context).x(10.0),
                                        Tela.de(context).y(10.0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              );
                            },
                          ),
                          SizedBox(height: Tela.de(context).y(10.0)),
                          FormField(
                            builder: (context4) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Confirmação da senha',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        Tela.de(context).x(10.0),
                                        Tela.de(context).y(10.0),
                                        Tela.de(context).x(10.0),
                                        Tela.de(context).y(10.0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }
}
