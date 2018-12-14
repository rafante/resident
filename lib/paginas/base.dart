import 'package:resident/imports.dart';

class BaseWindow extends StatefulWidget {
  final Widget conteudo;
  final PopScope popScope;
  BaseWindow({this.conteudo, this.popScope});
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
    return WillPopScope(
      onWillPop: () async {
        if (widget.popScope != null) {
          return widget.popScope.willPop();
        }
        return true;
      },
      child: Padding(
          padding: EdgeInsets.only(top: Tela.de(context).y(50.0)),
          child: widget.conteudo),
    );
  }
}

abstract class PopScope {
  bool willPop();
}
