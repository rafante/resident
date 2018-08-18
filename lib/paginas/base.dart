import 'package:flutter/material.dart';

class BaseWindow extends StatefulWidget {
  final Widget conteudo;
  BaseWindow({this.conteudo});
  @override
  _BaseWindowState createState() => _BaseWindowState();
}

class _BaseWindowState extends State<BaseWindow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: widget.conteudo,
      // child: Container(
      //   color: Colors.blueAccent,
      //   width: 100.0,
      //   height: 100.0,
      // ),
    );
  }
}
