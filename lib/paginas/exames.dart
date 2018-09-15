import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
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
      Map registro = evento.snapshot.value;
      List<Anexo> anexos = [];
      anexos.add(new Anexo(
          nome: registro['nome'],
          downloadLink: registro['link'],
          tamanho: registro['tamanho']));
      setState(() {
        _anexos = anexos;
      });
    });
  }

  Widget body() {
    List<DataRow> rows = [];
    for (Anexo anexo in _anexos) {
      rows.add(new DataRow(cells: [
        DataCell(Text(anexo.nome)),
        DataCell(Text(anexo.tamanho.toString())),
        // DataCell(Text('cba')),
        DataCell(IconButton(
            icon: Icon(Icons.pageview),
            onPressed: () async {
              String path = '${Directory.systemTemp.path}/${anexo.nome}.png';
              File arquivo = new File(path);
              print('o path do arquivo é $path');
              bool existe = arquivo.existsSync();
              print('o arquivo ${existe ? "existe" : "não existe"}');
              int tamanho = existe ? arquivo.readAsBytesSync().length : 0;
              print('o tamanho do arquivo é $tamanho');
              if (existe && (tamanho == 0 || tamanho != tamanho)) {
                arquivo.deleteSync();
              }
              if (tamanho == 0 || tamanho != anexo.tamanho) {
                await arquivo.create();
                assert(await arquivo.readAsString() == "");
                StorageReference ref = FirebaseStorage.instance
                    .ref()
                    .child('anexos')
                    .child('${anexo.nome}.png');

                print('iniciando o download');
                StorageFileDownloadTask dTask = ref.writeToFile(arquivo);
                dTask.future.then((snapshot) {
                  abrirArquivo(path);
                });
              } else if (existe && tamanho == anexo.tamanho) {
                abrirArquivo(path);
              }
            }))
      ]));
    }
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text('Descrição'),
        ),
        DataColumn(label: Text('Tamanho')),
        // DataColumn(label: Text('Formato')),
        DataColumn(label: Text('Ações')),
      ],
      rows: rows,
    );
  }

  void abrirArquivo(String path) async {
    await OpenFile.open(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exames'),
      ),
      body:
          SingleChildScrollView(scrollDirection: Axis.vertical, child: body()),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('')),
          BottomNavigationBarItem(icon: Icon(Icons.flag), title: Text('')),
        ],
      ),
    );
  }
}
