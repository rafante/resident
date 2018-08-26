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
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.0, 100.0, 40.0, 0.0),
        child: ListView(
          children: <Widget>[
            Center(child: Text('Remoção de propagandas')),
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: RaisedButton(
                color: Colors.greenAccent,
                child: Icon(Icons.attach_money, color: Colors.white),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 40.0),
            Center(child: Text('Liberar armazenamento na nuvem')),
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: RaisedButton(
                color: Colors.greenAccent,
                child: Icon(Icons.attach_money, color: Colors.white),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 40.0),
            Center(child: Text('Licença atual')),
            SizedBox(height: 30.0),
            Center(child: Text('FREE'))
          ],
        ),
      ),
    );
  }
}
