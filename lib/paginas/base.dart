import 'package:resident/imports.dart';

class BaseWindow extends StatefulWidget {
  final Widget conteudo;
  BaseWindow({this.conteudo});
  @override
  _BaseWindowState createState() => _BaseWindowState();
}

class _BaseWindowState extends State<BaseWindow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Padding(
        padding: EdgeInsets.only(top: Tela.de(context).y(50.0)),
        child: widget.conteudo);
  }
}
