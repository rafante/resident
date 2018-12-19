import 'package:flutter/rendering.dart';
import 'package:resident/imports.dart';

class ExamesPage extends StatefulWidget {
  static String tag = 'exames';
  final String pacienteNome;
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;

  ExamesPage({this.app, this.pacienteKey, this.grupoKey, this.pacienteNome});

  @override
  _ExamesPageState createState() => _ExamesPageState();
}

class _ExamesPageState extends State<ExamesPage> {
  List<Exame> _exames;
  String nomePaciente = 'carregando';

  @override
  void initState() {
    super.initState();
    if (widget.pacienteNome != null) nomePaciente = widget.pacienteNome;
    Firestore.instance
        .collection('exames')
        .where('pacienteKey', isEqualTo: widget.pacienteKey)
        .snapshots()
        .listen((snap) {
      if (snap.documents != null) {
        List<Exame> exames = [];
        snap.documents.forEach((documento) {
          exames.add(Exame(
              nome: documento.data['nome'],
              tamanho: documento.data['tamanho'],
              anexo: documento.data['anexo'],
              extensao: documento.data['extensao'],
              pacienteKey: documento.data['pacienteKey'],
              key: documento.data['key'],
              descricao: documento.data['descricao'],
              downloadLink: documento.data['downloadLink']));
        });
        if (mounted) {
          setState(() {
            _exames = exames;
          });
        }
      }
    });
  }

  Widget body() {
    List<DataRow> rows = [];
    if (_exames != null) {
      for (Exame exame in _exames) {
        String unit = 'Kb';

        double size = exame.tamanho / 1024;
        if (size > 1000) {
          unit = 'Mb';
          size /= 1024;
        }

        if (size > 1000) {
          unit = 'Gb';
          size /= 1024;
        }

        String tamanhoStr = '${size.toStringAsFixed(1)} $unit';
        rows.add(new DataRow(cells: [
          DataCell(Text(exame.nome)),
          DataCell(Text(tamanhoStr)),
          DataCell(Text(exame.extensao)),
          DataCell(Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.pageview),
                  onPressed: () async {
                    if (exame.extensao != 'doc')
                      Exame.abrirAnexoExame(context, exame: exame);
                    else
                      Exame.popupInsereDocumentoExame(context,
                          pacienteKey: widget.pacienteKey,
                          nome: exame.nome,
                          descricao: exame.descricao,
                          documentID: exame.key);
                  })
            ],
          ))
        ]));
      }
    }
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text('Descrição'),
        ),
        DataColumn(label: Text('Tamanho')),
        DataColumn(label: Text('Formato')),
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
    Navegador.tagAtual = Tag.EXAMES;
    return Scaffold(
        appBar: AppBar(
          title: Text('Exames'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Exame.popupInsereDocumentoExame(context,
                pacienteKey: widget.pacienteKey);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: Tela.de(context).y(10.0)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Tela.de(context).x(24.0)),
                child: Text('Paciente: $nomePaciente'),
              ),
              body()
            ],
          ),
          scrollDirection: Axis.horizontal,
        ));
  }
}
