import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resident/componentes/card_contato.dart';
import 'package:resident/entidades/contato.dart';
import 'package:resident/entidades/dados_grupo.dart';
import 'package:resident/entidades/usuarios.dart';

//Classe que mostra as coisas
class DadosGrupoPage extends StatefulWidget {
  final FirebaseApp app;
  final String grupoChave;
  DadosGrupoPage({this.app, this.grupoChave = ''});

  @override
  State<StatefulWidget> createState() {
    return _DadosGrupoPageState();
  }
}

class ContatoCard {
  Contato contato;
  bool adicionado = false;
  ContatoCard({this.contato, this.adicionado});
}

//Classe que controla a classe que mostra as coisas (Principal)
class _DadosGrupoPageState extends State<DadosGrupoPage> {
  DadosGrupo _dadosGrupo;
  String titulo = 'Novo grupo';
  TextEditingController _nomeDoGrupo = TextEditingController(text: '');
  TextEditingController _descricao = TextEditingController(text: '');
  List<Usuario> contatos = [];
  List<ContatoCard> lista = [];

  @override
  void initState() {
    super.initState();
    if (widget.grupoChave == null || widget.grupoChave == '')
      _dadosGrupo = new DadosGrupo();
    else
      _dadosGrupo = new DadosGrupo(chave: widget.grupoChave);
    _dadosGrupo.getDados().then((DadosGrupo dados) {
      setState(() {
        _nomeDoGrupo.text = dados.nome;
        _descricao.text = dados.descricao;
      });
    });
  }

  void setar(String nome, String descricao, List<Usuario> contatos) {
    _dadosGrupo.nome = nome;
    _dadosGrupo.descricao = descricao;
    _dadosGrupo.contatos = contatos;
    _dadosGrupo.salvar();
  }

  Future<List<Usuario>> listaContatos() async {
    return showDialog<List<Usuario>>(
        context: context,
        builder: (context) {
          List<Usuario> lista = [];
          return Padding(
            padding: EdgeInsets.all(25.0),
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
    List<Widget> lista = [];
    var todosOsContatos = Usuario.logado().contatos;
    todosOsContatos.forEach((Usuario contato) {
      lista.add(CardSelecionaContato(
        contato: contato,
        selecao: true,
      ));
    });
    List<Usuario> _contatos = await showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 120.0),
            child: Container(
              color: Colors.white,
              child: Column(children: [
                Expanded(
                    child: Container(
                  child: ListView(
                    children: lista,
                  ),
                )),
                SizedBox(
                  height: 50.0,
                  child: FloatingActionButton(
                    child: Icon(Icons.done),
                    onPressed: () {
                      List<Usuario> _contatos = [];
                      lista.forEach((Widget cont) {
                        CardSelecionaContato cardCont = cont;
                        if (cardCont != null && cardCont.marcado) {
                          _contatos.add(cardCont.contato);
                        }
                      });
                      if (_contatos == null) _contatos = [];
                      Navigator.pop(context, _contatos);
                    },
                  ),
                )
              ]),
            ),
          ); 
        });

    setState(() {
      if (_contatos != null) contatos = _contatos;
    });
  }

  List<Widget> contatosSelecionadosCards() {
    List<Widget> lista = [];
    lista.add(MaterialButton(
      onPressed: () {
        abrirSelecaoContatos();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.add), Text('Add contato')],
      ),
    ));
    contatos.forEach((Usuario contato) {
      lista.add(CardSelecionaContato(contato: contato));
    });

    return lista;
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
          SizedBox(height: 10.0),
          FloatingActionButton(
            child: Icon(Icons.done_outline),
            onPressed: () {
              setState(() {
                titulo = _nomeDoGrupo.text;
                setar(_nomeDoGrupo.text, _descricao.text, contatos);
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextFormField(
              controller: _nomeDoGrupo,
              maxLength: 40,
              decoration: InputDecoration(
                  labelText: 'Nome do grupo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
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
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 300.0,
              child: Container(
                child: ListView(children: contatosSelecionadosCards()),
              ),
            ),
          )

          // ListView(
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[],
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
