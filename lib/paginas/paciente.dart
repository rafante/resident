import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resident/componentes/bubble.dart';
import 'package:resident/componentes/mensagem.dart';
import 'dart:io';

import 'package:resident/entidades/paciente_class.dart';
import 'exames.dart';
import 'package:resident/entidades/usuarios.dart';
import 'package:resident/paginas/base.dart';

class PacientePage extends StatefulWidget {
  static String tag = 'paciente-page';
  final Paciente paciente;
  final FirebaseApp app;
  final String pacienteKey;
  PacientePage({this.app, this.paciente, this.pacienteKey});
  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  List<Mensagem> _mensagens = <Mensagem>[];

  TextEditingController _textController = TextEditingController(text: '');
  bool _isWriting;
  Future<File> _imageFile;

  @override
  void initState() {
    super.initState();
    DatabaseReference db = FirebaseDatabase.instance.reference();
    db.child('chats').child(widget.pacienteKey).onValue.listen((Event evento) {
      Map eventoMsgs = evento.snapshot.value;
      List<Mensagem> mensagens = <Mensagem>[];
      if (eventoMsgs != null) {
        eventoMsgs.forEach((chave, valor) {
          mensagens.add(new Mensagem(
              chave: chave,
              autor: valor['autor'],
              hora: new DateTime.fromMillisecondsSinceEpoch(valor['hora']),
              texto: valor['texto']));
        });
        mensagens.sort((msg1, msg2) {
          return msg2.hora.compareTo(msg1.hora);
        });
        setState(() {
          _mensagens = mensagens;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.purpleAccent,
          title: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(widget.paciente.nome),
          )),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, int indice) {
                Mensagem msg = _mensagens[indice];
                String horaFormatada = DateFormat('HH:mm').format(msg.hora);
                return Bubble(
                    message: msg.texto,
                    time: msg.hora != null ? horaFormatada : '',
                    isMe: msg.autor == Usuarios.logado(),
                    delivered: true);
              },
              itemCount: _mensagens.length,
              reverse: true,
              padding: EdgeInsets.all(10.0),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            child: _construirComposer(),
            decoration: BoxDecoration(color: Colors.purpleAccent),
          )
        ],
      ),
      endDrawer: Drawer(
        elevation: 1.0,
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: Icon(Icons.assignment),
              title: Text('Exames'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return BaseWindow(
                    conteudo: ExamesPage(
                        app: widget.app, pacienteKey: widget.pacienteKey),
                  );
                })));
              },
            )
          ],
        ),
      ),
    );
  }

  IconButton _botaoAnexar() {
    return IconButton(
      icon: Icon(
        Icons.attach_file,
        color: Colors.white,
      ),
      onPressed: () {
        criarAnexo();
      },
    );
  }

  void criarAnexo() {
    ImagePicker.pickImage(source: ImageSource.camera).then((File imagem) async {
      if (imagem == null) return;
      File arquivo = new File(imagem.path);
      Mensagem linkMsg = criarMensagem(
          Usuarios.logado(), 'carregando arquivo...', DateTime.now());
      salvarMensagem(linkMsg);
      DatabaseReference ref = FirebaseDatabase.instance
          .reference()
          .child('anexos')
          .child(widget.pacienteKey);
      String chave = ref.push().key;
      StorageReference sRef =
          FirebaseStorage.instance.ref().child('anexos').child('$chave.png');
      StorageUploadTask task = sRef.putFile(arquivo);
      task.future.then((UploadTaskSnapshot snapshot) async {
        Uri downloadLink = snapshot.downloadUrl;
        ref.child(chave).child('link').set(downloadLink.toString());
        ref.child(chave).child('nome').set('foto');
        // DatabaseReference chats = FirebaseDatabase.instance.reference().child('chats').child(widget.pacienteKey);
        // String msgKey = chats.push().key;
        linkMsg.texto = downloadLink.toString();
        salvarMensagem(linkMsg);
        // int anexos;
        // await ref.once().then((DataSnapshot snapshot) {
        //   Map<dynamic, dynamic> map = snapshot.value;
        //   List list = map.values.toList();
        //   anexos = snapshot.value != null ? snapshot.value.keys.length : 0;
        // });
        // if (anexos == 0) {
        //   String chave = ref.push().key;

        //   ref.child(chave).child('link').set(downloadLink.toString());
        //   ref.child(chave).child('nome').set('foto');
        // }
      });
    }).catchError((erro) {});
  }

  Mensagem criarMensagem(String autor, String texto, DateTime hora) {
    Mensagem mensagem = new Mensagem(texto: texto, hora: hora, autor: autor);
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(widget.pacienteKey);
    mensagem.chave = ref.push().key;
    return mensagem;
  }

  void salvarMensagem(Mensagem mensagem) {
    DatabaseReference db = FirebaseDatabase.instance.reference();
    db = db.child('chats').child(widget.pacienteKey).child(mensagem.chave);
    db.child('hora').set(mensagem.hora.millisecondsSinceEpoch);
    db.child('texto').set(mensagem.texto);
    db.child('autor').set(mensagem.autor);
  }

  Widget _construirComposer() {
    return IconTheme(
      data: new IconThemeData(color: Colors.purpleAccent),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 29.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: TextField(
                  controller: _textController,
                  onChanged: (String textoDigitado) {},
                  decoration:
                      InputDecoration.collapsed(hintText: 'Digite aqui')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: <Widget>[
                  _botaoAnexar(),
                  IconButton(
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_textController.text == '') return;
                      DatabaseReference db =
                          FirebaseDatabase.instance.reference();
                      db = db.child('chats').child(widget.pacienteKey);
                      String key = db.push().key;

                      Mensagem mensagem = new Mensagem(
                        texto: _textController.text,
                        hora: DateTime.now(),
                        autor: Usuarios.logado(),
                        chave: key,
                      );
                      db
                          .child(key)
                          .child('hora')
                          .set(mensagem.hora.millisecondsSinceEpoch);
                      db.child(key).child('texto').set(mensagem.texto);
                      db.child(key).child('autor').set(mensagem.autor);

                      setState(() {
                        // _mensagens.add(mensagem);
                        // _mensagens = _mensagens.reversed.toList();
                        _textController.text = '';
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
