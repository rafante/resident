import 'package:resident/imports.dart';

class BaseWindow extends StatefulWidget {
  final Widget conteudo;
  final PopScope popScope;
  BaseWindow({this.conteudo, this.popScope});
  @override
  _BaseWindowState createState() => _BaseWindowState();
}

class _BaseWindowState extends State<BaseWindow> {
  String _pagina;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _pagina = getConteudo().toString();
    return WillPopScope(
      onWillPop: () async {
        if (_pagina == 'LoginPage') return false;

        if (_pagina == 'GruposPage') return false;

        if (_pagina == 'PerfilPage' && !Usuario.valido()) return false;

        return true;
      },
      child: Padding(
          padding: EdgeInsets.only(top: Tela.de(context).y(50.0)),
          child: getConteudo()),
    );
  }

  Widget getConteudo() {
    if (widget.conteudo == null) {
      if (Usuario.valido()) {
        return GruposPage();
      } else {
        return PerfilPage();
      }
    } else
      return widget.conteudo;
  }
}

abstract class PopScope {
  bool willPop();
}
