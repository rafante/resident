import 'package:resident/imports.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    verificarUsuario();
    return Scaffold();
  }

  void verificarUsuario() {
    if (!Usuario.estaLogado()) {
      Navegador.de(context).navegar(Tag.LOGIN, null);
    } else {
      if (Usuario.eu['idResidente'] == null || Usuario.eu['telefone'] == null) {
        Navegador.de(context).navegar(Tag.PERFIL, null);
      }
    }
  }
}
