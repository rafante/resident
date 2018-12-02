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
              tamanho: documento.data['tamanho'],
              anexo: documento.data['anexo'],
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
        rows.add(new DataRow(cells: [
          DataCell(Text(exame.nome)),
          DataCell(Text(exame.tamanho.toString())),
          // DataCell(Text('cba')),
          DataCell(IconButton(
              icon: Icon(Icons.pageview),
              onPressed: () async {
                Exame.abrirAnexoExame(exame: exame);
              }))
        ]));
      }
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Exame.criarAnexo(context, TipoExame.ANEXO, widget.pacienteKey);
          },
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
