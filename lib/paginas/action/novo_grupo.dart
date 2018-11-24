import 'package:resident/imports.dart';

//Classe que mostra as coisas
class DadosGrupoPage extends StatefulWidget {
  final String grupoChave;
  DadosGrupoPage({this.grupoChave = ''});

  @override
  State<StatefulWidget> createState() {
    return _DadosGrupoPageState();
  }
}

//Classe que controla a classe que mostra as coisas (Principal)
class _DadosGrupoPageState extends State<DadosGrupoPage> {
  String titulo = 'Novo grupo';
  TextEditingController _nomeDoGrupo = TextEditingController(text: '');
  TextEditingController _descricao = TextEditingController(text: '');
  Map<String, dynamic> grupo;
  List _contatos;

  @override
  void initState() {
    super.initState();
    grupo = Map();
    _contatos = [];
    if (widget.grupoChave == null || widget.grupoChave == '')
      grupo = {'nome': '', 'descricao': '', 'contatos': []};
    else {
      grupo = Banco.findGrupo(widget.grupoChave);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: Tela.de(context).y(10.0)),
          FloatingActionButton(
            child: Icon(Icons.done_outline),
            onPressed: () {
              setState(() {
                grupo['nome'] = _nomeDoGrupo.text;
                grupo['descricao'] = _descricao.text;
                grupo['contatos'] = _contatos;
                titulo = grupo['nome'];
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: Tela.de(context).y(20.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(50.0)),
            child: TextFormField(
              controller: _nomeDoGrupo,
              maxLength: 40,
              decoration: InputDecoration(
                  labelText: 'Nome do grupo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Tela.de(context).abs(20.0))))),
            ),
          ),
          SizedBox(height: Tela.de(context).y(20.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(50.0)),
            child: TextFormField(
              maxLength: 240,
              maxLines: 10,
              controller: _descricao,
              decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
          ),
          SizedBox(height: Tela.de(context).y(20.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Tela.de(context).x(20.0)),
            child: SizedBox(
              height: Tela.de(context).y(300.0),
              child: Container(
                child: ListView(children: _contatosWidgets()),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _contatosWidgets() {
    List<Widget> contatosWidgets = [];
    contatosWidgets.add(SizedBox(
      height: Tela.de(context).y(50.0),
      child: MaterialButton(
        child: Text(
          '+ Add contato',
          style: TextStyle(fontSize: Tela.de(context).abs(25.0)),
        ),
        onPressed: () {
          setState(() {
            grupo['contatos'] = [];
          });
          abrirSelecaoContatos();
        },
      ),
    ));
    grupo['contatos'].forEach((contato) {
      Map<String, dynamic> contatoBanco = Banco.findUsuario(contato);
      contatosWidgets.add(Card(
        child: ListTile(
          title: Text(contatoBanco['nome']),
          trailing: Checkbox(
            value: !false,
            onChanged: (marcado) {},
          ),
          leading: CircleAvatar(
            child: Image.network(contatoBanco['urlFoto']),
          ),
        ),
      ));
    });
    return contatosWidgets;
  }

  Future<List<Usuario>> listaContatos() async {
    double h, v;
    h = Tela.de(context).x(25.0);
    v = Tela.de(context).x(25.0);
    return showDialog<List<Usuario>>(
        context: context,
        builder: (context) {
          List<Usuario> lista = [];
          return Padding(
            padding: EdgeInsets.fromLTRB(h, v, h, v),
            child: Center(
              child: Container(
                color: Colors.amberAccent,
                child: ListView(
                  children: <Widget>[],
                ),
              ),
            ),
          );
        });
  }

  Future<Null> abrirSelecaoContatos() async {
    List lista = grupo['contatos'];
    var _contatos = await showDialog(
        context: context,
        builder: (context) {
          return ContatosGrupo(lista: lista);
        });

    setState(() {
      if (_contatos != null)
        grupo['contatos'] = ['cJH7EH0ze9hta0mlrcE3wUk78Uz2'];
      Banco.atualizarGrupo(null,
          nome: grupo['nome'],
          descricao: grupo['descricao'],
          contatos: grupo['contatos']);
    });
  }
}

class ContatosGrupo extends StatefulWidget {
  final List lista;
  ContatosGrupo({this.lista});
  _ContatosGrupoState createState() => _ContatosGrupoState();
}

class ContatoCard {
  String nome;
  bool adicionado = false;
  ContatoCard({this.nome, this.adicionado});
}

class _ContatosGrupoState extends State<ContatosGrupo> {
  List contatos = [];
  List<String> selecionados = [];
  List<Widget> contatosWidgets = [];
  List<ContatoCard> contatosCards = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> contsCards() {
    List<Widget> _lista = [];
    if (Usuario.eu['contatos'] != null) {
      Usuario.eu['contatos'].forEach((cont) {
        Map contato = Banco.findUsuario(cont);
        _lista.add(Card(
          child: ListTile(
            title: Text(contato['nome']),
            trailing: Checkbox(
              value: selecionados.contains(cont),
              onChanged: (bool marcado) {
                List<String> _conts = [];
                _conts.addAll(selecionados);
                if (marcado && !selecionados.contains(cont)) {
                  _conts.add(contato['uid']);
                } else if (!marcado && selecionados.contains(cont)) {
                  _conts.remove(contato['uid']);
                }
                setState(() {
                  selecionados = _conts;
                });
              },
            ),
          ),
        ));
      });
    }
    return _lista;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Tela.de(context).x(50.0),
          vertical: Tela.de(context).y(120.0)),
      child: Container(
        color: Colors.white,
        child: Column(children: [
          Expanded(
              child: Container(
            child: ListView(
              children: contsCards(),
            ),
          )),
          SizedBox(
            height: Tela.de(context).y(50.0),
            child: FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () {
                Navigator.pop(context, selecionados);
              },
            ),
          )
        ]),
      ),
    );
  }
}
