import 'package:resident/imports.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    verificarUsuario();
    Navigator.of(context).pushNamed(GruposPage.tag);
    return Scaffold();
  }

  void verificarUsuario() {
    if (!Usuario.estaLogado()) {
      Navigator.of(context).pushNamed(LoginPage.tag);
    } else {
      if (Usuario.eu['idResidente'] == null || Usuario.eu['telefone'] == null) {
        Navigator.of(context).pushNamed(PerfilPage.tag);
      }
    }
  }
}
