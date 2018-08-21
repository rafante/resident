import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resident/entidades/dados_grupo.dart';

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

//Classe que controla a classe que mostra as coisas (Principal)
class _DadosGrupoPageState extends State<DadosGrupoPage> {
  DadosGrupo _dadosGrupo;
  String titulo = 'Novo grupo';
  TextEditingController _nomeDoGrupo = TextEditingController(text: '');
  TextEditingController _descricao = TextEditingController(text: '');
  List<Map> _contatos;
  bool _marcado = true;
  List<MapEntry> lista = [
    MapEntry('Juscelino', false),
    MapEntry('Warley', false),
    MapEntry('Lindsey', false),
    MapEntry('Melanucha', false),
    MapEntry('Bruno', false),
    MapEntry('Fulano', false),
    MapEntry('Jaunio', false),
  ];

  @override
  void initState() {
    super.initState();
    _contatos = [];
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

  void setar(String nome, String descricao) {
    _dadosGrupo.nome = nome;
    _dadosGrupo.descricao = descricao;
    _dadosGrupo.salvar();
  }

  List<Widget> _getContatos() {
    List<Card> cartoes = [];
    lista.forEach((MapEntry contato) {
      cartoes.add(new Card(
        child: ListTile(
          leading: Checkbox(
            onChanged: (bool marcado) {
              setState(() {
                contato = MapEntry(contato.key, marcado);
              });
            },
            value: contato.value,
          ),
          title: Text(contato.key),
        ),
      ));
    });
    return cartoes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done_outline),
        onPressed: () {
          setState(() {
            titulo = _nomeDoGrupo.text;
            setar(_nomeDoGrupo.text, _descricao.text);
            Navigator.pop(context);
          });
        },
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
                child: ListView(
                  children: _getContatos(),
                ),
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
