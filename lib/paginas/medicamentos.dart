import 'package:intl/intl.dart';
import 'package:resident/imports.dart';

class MedicamentosPage extends StatefulWidget {
  final FirebaseApp app;
  final String pacienteKey;
  final String grupoKey;
  static String tag = 'medicamentos';
  MedicamentosPage({this.app, this.pacienteKey, this.grupoKey});
  _MedicamentosPageState createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  Paciente paciente;
  String nomePaciente;
  List<AplicacaoMedicamento> medicamentos = [];

  Widget tabela() {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(label: Text('Descrição')),
        DataColumn(label: Text('Tipo')),
        DataColumn(label: Text('Data/Hora'))
      ],
      rows: linhas(),
    );
  }

  List<DataRow> linhas() {
    List<DataRow> lns = [];
    for (int i = 0; i < medicamentos.length; i++) {
      var medicamento = medicamentos[i];
      lns.add(DataRow(cells: <DataCell>[
        DataCell(Text(medicamento.descricao)),
        DataCell(Text(medicamento.tipo)),
        DataCell(Text(
            new DateFormat('dd/MM/yyyy HH:mm:ss').format(medicamento.horario)))
      ]));
    }
    return lns;
  }

  @override
  void initState() {
    nomePaciente = 'Aguarde, carregando...';
    carregarPaciente().then((Paciente pac) {
      paciente = pac;
    });
    Firestore.instance
        .collection('medicamentos')
        .where('pacienteKey', isEqualTo: widget.pacienteKey)
        .snapshots()
        .listen((snap) {
      if (snap.documents != null) {
        List<AplicacaoMedicamento> lista = [];

        snap.documents.forEach((documento) {
          DateTime horario = DateTime.now();
          if (documento.data['horario'] != null)
            horario =
                DateTime.fromMillisecondsSinceEpoch(documento.data['horario']);
          AplicacaoMedicamento aplicacao = AplicacaoMedicamento(
            descricao: documento.data['descricao'],
            horario: horario,
            pacienteKey: documento.data['pacienteKey'],
            tipo: documento.data['tipo'],
            key: documento.documentID,
          );
          lista.add(aplicacao);
        });

        if (mounted) {
          setState(() {
            medicamentos = lista;
          });
        }
      }
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicamentos'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                Tela.de(context).x(20.0),
                Tela.de(context).y(20.0),
                Tela.de(context).x(20.0),
                Tela.de(context).y(20.0)),
            child: Text('Paciente: $nomePaciente'),
          ),
          tabela()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new BaseWindow(
              conteudo: new MedicamentoDetalhe(pacienteKey: widget.pacienteKey),
            );
          }));
        },
      ),
    );
  }

  Future<Paciente> carregarPaciente() async {
    return await Paciente.buscar(widget.pacienteKey);
  }
}
