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
  Paciente _paciente;
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
    // _paciente = new Paciente(
    //     key: widget.pacienteKey,
    //     grupoKey: widget.grupoKey,
    //     forcarOnline: false);
    // _paciente.carregaDadosDoServidor().then((teste) {
    //   setState(() {
    //     nomePaciente = _paciente.nome;
    //   });
    // });
    // var ref = Banco.ref();
    // ref
    //     .child('pacientes')
    //     .child(widget.pacienteKey)
    //     .child('medicamentos')
    //     .onValue
    //     .listen((evento) {
    //   Map meds = evento.snapshot.value;
    //   List<AplicacaoMedicamento> lista = [];
    //   if (meds != null) {
    //     meds.forEach((chave, valor) {
    //       var medicamento = new AplicacaoMedicamento(
    //           key: chave,
    //           tipo: valor['tipo'],
    //           descricao: valor['descricao'],
    //           horario: DateTime.fromMillisecondsSinceEpoch(valor['horario']));
    //       lista.add(medicamento);
    //     });
    //     lista.sort((AplicacaoMedicamento ap1, AplicacaoMedicamento ap2) {
    //       return ap2.horario.compareTo(ap1.horario);
    //     });
    //     setState(() {
    //       medicamentos = lista;
    //     });
    //   }
    // });

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
              Tela.de(context).y(20.0)
            ),
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
}
