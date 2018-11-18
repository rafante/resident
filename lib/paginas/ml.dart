
import 'package:resident/imports.dart';

class VisionPage extends StatefulWidget {
  static String tag = 'vision';
  final FirebaseApp app;

  VisionPage({this.app});
  _VisionPageState createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  File _imagem;
  String _texto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: Tela.de(context).y(200.0),
            color: Colors.amberAccent,
            child: Center(
              child: Text(_texto != null ? _texto : ""),
            ),
          ),
          _imagem != null
              ? Image.file(
                  _imagem,
                  height: Tela.de(context).y(400.0),
                )
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          verificarImagem();
        },
      ),
    );
  }

  Future<void> verificarImagem() async {
    File imagem = await ImagePicker.pickImage(source: ImageSource.camera);
    String texto = await Identificador.identificarImagem(imagem);
    setState(() {
      _imagem = imagem;
      _texto = texto;
    });
  }
}
