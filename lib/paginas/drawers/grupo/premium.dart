import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  final FirebaseApp app;
  PremiumPage({this.app});

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seja premium!'),
      ),
    );
  }
}
