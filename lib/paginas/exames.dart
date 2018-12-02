import 'package:resident/imports.dart';

class ExamesPage extends StatefulWidget {
  static String tag = 'exames';
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;

  ExamesPage({this.app, this.pacienteKey, this.grupoKey});

  @override
  _ExamesPageState createState() => _ExamesPageState();
}

class _ExamesPageState extends State<ExamesPage> {
  List<Exame> _exames;

  @override
  void initState() {
    super.initState();
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
              descricao: documento.data['descricao'],
              downloadLink: documento.data['downloadLink']));
        });
        setState(() {
          _exames = exames;
        });
      }
    });
  }

  Widget body() {
    List<DataRow> rows = [];
    for (Exame exame in _exames) {
      rows.add(new DataRow(cells: [
        DataCell(Text(exame.nome)),
        DataCell(Text(exame.tamanho.toString())),
        // DataCell(Text('cba')),
        DataCell(IconButton(
            icon: Icon(Icons.pageview),
            onPressed: () async {
              String path = '${Directory.systemTemp.path}/${exame.key}.png';
              File arquivo = new File(path);
              // print('o path do arquivo é $path');
              bool existe = arquivo.existsSync();
              // print('o arquivo ${existe ? "existe" : "não existe"}');
              int tamanho = existe ? arquivo.readAsBytesSync().length : 0;
              // print('o tamanho do arquivo é $tamanho');
              if (existe && (tamanho == 0 || tamanho != tamanho)) {
                arquivo.deleteSync();
              }
              if (tamanho == 0 || tamanho != exame.tamanho) {
                await arquivo.create();
                assert(await arquivo.readAsString() == "");
                StorageReference ref = FirebaseStorage.instance
                    .ref()
                    .child('anexos')
                    .child('${exame.nome}.png');

                // print('iniciando o download');
                StorageFileDownloadTask dTask = ref.writeToFile(arquivo);
                dTask.future.then((snapshot) {
                  abrirArquivo(path);
                });
              } else if (existe && tamanho == exame.tamanho) {
                abrirArquivo(path);
              }
            }))
      ]));
    }
    return ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Tela.de(context).x(20.0),
                vertical: Tela.de(context).y(5.0)),
            child: Text(
              'Paciente: teste',
              style: TextStyle(fontSize: Tela.de(context).abs(15.0)),
            )),
        DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Text('Descrição'),
            ),
            DataColumn(label: Text('Tamanho')),
            // DataColumn(label: Text('Formato')),
            DataColumn(label: Text('Ações')),
          ],
          rows: rows,
        )
      ],
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
        body: Padding(
            padding: EdgeInsets.fromLTRB(
                Tela.de(context).x(10.0),
                Tela.de(context).y(10.0),
                Tela.de(context).x(10.0),
                Tela.de(context).y(10.0)),
            child: body()));
  }
}
