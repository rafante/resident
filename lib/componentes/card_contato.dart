import 'package:resident/imports.dart';

class CardSelecionaContato extends StatefulWidget {
  Usuario contato;
  bool selecao;
  bool marcado;
  CardSelecionaContato({this.contato, this.selecao = false});

  _CardSelecionaContatoState createState() => _CardSelecionaContatoState();
}

class _CardSelecionaContatoState extends State<CardSelecionaContato> {
  bool _marcado = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(widget.contato.urlFoto),
        ),
        trailing: widget.selecao ? Checkbox(
          value: _marcado,
          onChanged: (marcado) {
            setState(() {
              _marcado = marcado;
              widget.marcado = _marcado;
            });
          },
        ) : null,
        title: Text(widget.contato.nome),
        subtitle: Text(widget.contato.email),
      ),
    );
  }
}
