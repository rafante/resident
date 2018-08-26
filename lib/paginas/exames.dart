import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:resident/entidades/anexo.dart';
import 'package:resident/entidades/usuarios.dart';

class ExamesPage extends StatefulWidget {
  static String tag = 'exames';
  final FirebaseApp app;
  final String pacienteKey;

  ExamesPage({this.app, this.pacienteKey});

  @override
  _ExamesPageState createState() => _ExamesPageState();
}

class _ExamesPageState extends State<ExamesPage> {
  List<Anexo> _anexos;

  @override
  void initState() {
    super.initState();
    if (_anexos == null) _anexos = [];
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref
        .child('anexos')
        .child(widget.pacienteKey)
        .onValue
        .listen((Event evento) async {
      Map registros = evento.snapshot.value;
      List<Anexo> anexos = [];
      registros.values.toList().forEach((registro) {
        anexos.add(
            new Anexo(nome: registro['nome'], downloadLink: registro['link']));
      });
      setState(() {
        _anexos = anexos;
      });
    });
  }

  Future<Null> popupExibeImagem(String link) async {
    Usuarios.logado();
    await showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
            child: new Container(
              width: 100.0,
              height: 100.0,
              color: Colors.amberAccent,
              child: Image.asset(link),
            ),
          );
        });
    return null;
  }

  Widget body() {
    List<DataRow> rows = [];
    for (Anexo anexo in _anexos) {
      rows.add(new DataRow(cells: [
        DataCell(Text(anexo.nome)),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text(anexo.downloadLink), onTap: () async {
          final Directory temp = Directory.systemTemp;
          final File file = new File('${temp.path}/${widget.pacienteKey}.png');

          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child('anexos')
              .child('${widget.pacienteKey}.png');
          StorageFileDownloadTask downloadTask = ref.writeToFile(file);

          final int totalBytes = (await downloadTask.future).totalByteCount;
          print(totalBytes);

          await popupExibeImagem(file.path);

          // final http.Response downloadData = await http.get(anexo.downloadLink);
          // final String name = await ref.getName();
          // final String bucket = await ref.getBucket();
          // final String path = await ref.getPath();
          // final Directory systemTempDir = Directory.systemTemp;
          // final File tempFile = new File('$systemTempDir/tmp.png');
          // if (tempFile.existsSync()) {
          //   await tempFile.delete();
          // }
          // await tempFile.create();
          // assert(await tempFile.readAsString() == "");
          // final StorageFileDownloadTask task = ref.writeToFile(tempFile);
          // final int byteCount = (await task.future).totalByteCount;
          // final String tempFileContents = await tempFile.readAsString();
          // String kTestString = "Hello world";
          // assert(tempFileContents == kTestString);
          // assert(byteCount == kTestString.length);

          // setState(() {
          //   _fileContents = downloadData.body;
          //   _name = name;
          //   _path = path;
          //   _bucket = bucket;
          //   _tempFileContents = tempFileContents;
          // });
        }),
      ]));
    }
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text('Descrição'),
        ),
        DataColumn(label: Text('Data/Hora')),
        DataColumn(label: Text('Formato')),
        DataColumn(label: Text('Ações')),
      ],
      rows: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exames'),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: body()),
        scrollDirection: Axis.horizontal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('')),
          BottomNavigationBarItem(icon: Icon(Icons.flag), title: Text('')),
        ],
      ),
    );
  }
}
