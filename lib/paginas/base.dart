import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resident/utilitarios/shared_prefs.dart';

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
