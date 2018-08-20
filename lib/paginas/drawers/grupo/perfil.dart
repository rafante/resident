import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  final FirebaseApp app;
  PerfilPage({this.app});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done_outline),
        onPressed: () {

        },
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: CircleAvatar(
                backgroundImage: new NetworkImage(
                    'https://as1.ftcdn.net/jpg/01/87/93/48/500_F_187934820_dikL64zqcT1uEWwihWlTlopRXIe62D8V.jpg'),
                radius: 100.0,
              )),
          SizedBox(height: 30.0),
          Center(
              child: Text('Alterar imagem',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: 'Nome',
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1.0))),
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1.0))),
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: 'Telefone',
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1.0))),
            ),
          ),
        ],
      ),
    );
  }
}
