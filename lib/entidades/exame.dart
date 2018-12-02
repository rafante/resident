import 'package:resident/imports.dart';

class Exame {
  String key;
  String pacienteKey;
  String descricao;
  String nome;
  String downloadLink;
  int tamanho;

  Exame({this.descricao, this.nome, this.downloadLink, this.tamanho});

  static Future<TipoAnexo> popupTipoAnexo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(
                horizontal: Tela.de(context).x(30.0),
                vertical: Tela.de(context).y(30.0)),
            title: Title(
                color: Colors.black, child: Text('O que deseja inserir?')),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            children: <Widget>[
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    Text(
                      'Imagem',
                      style: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, TipoAnexo.IMAGEM);
                },
              ),
              SizedBox(
                height: Tela.de(context).y(10.0),
              ),
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.videocam),
                    Text(
                      'Video',
                      style: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, TipoAnexo.VIDEO);
                },
              ),
              SizedBox(
                height: Tela.de(context).y(10.0),
              ),
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.filePdf),
                    Text(
                      'Documento',
                      style: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, TipoAnexo.DOCUMENTO);
                },
              )
            ],
          );
        });
  }

  static Future<ImageSource> popupCameraGaleria(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    SizedBox(width: 5),
                    Text(
                      'Camera',
                      style: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                child: Row(children: [
                  Icon(Icons.view_carousel),
                  SizedBox(width: 5),
                  Text(
                    'Galeria',
                    style: TextStyle(fontSize: Tela.de(context).abs(20.0)),
                  )
                ]),
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Tela.de(context).abs(10.0)))),
          );
        });
  }

  static Future<Null> criarAnexo(
      BuildContext context, TipoExame tipo, String pacienteKey) async {
    if (pacienteKey == null) return;
    if (tipo == TipoExame.ANEXO) {
      TipoAnexo tipoAnexo = await popupTipoAnexo(context);
      ImageSource fonteImagem;
      File file;
      switch (tipoAnexo) {
        case TipoAnexo.IMAGEM:
          fonteImagem = await popupCameraGaleria(context);
          if (fonteImagem != null) file = await colheImagem(fonteImagem);
          break;
        case TipoAnexo.VIDEO:
          fonteImagem = await popupCameraGaleria(context);
          if (fonteImagem != null) file = await colheVideo(fonteImagem);
          break;
        case TipoAnexo.DOCUMENTO:
          break;
      }
      if (file == null) return;
      DocumentReference anexoRef = await Firestore.instance
          .collection('anexos')
          .add({'pacienteKey': pacienteKey});

      DocumentReference exameRef = await Firestore.instance
          .collection('exames')
          .add({
        'nome': '',
        'pacienteKey': pacienteKey,
        'anexo': anexoRef.documentID
      });
      //Cria a mensagem

      upload(file, anexoRef.documentID);
    }
  }

  static Future<String> upload(File fle, String chave) async {
    StorageReference sRef =
        FirebaseStorage.instance.ref().child('anexos').child('$chave.png');

    final File arquivo =
        await new File('${Directory.systemTemp.path}/$chave.png').create();

    List<int> imagemBytes = fle.readAsBytesSync();

    arquivo.writeAsBytesSync(imagemBytes);

    StorageUploadTask task = sRef.putFile(arquivo);
    final Uri downloadUrl = (await task.onComplete).uploadSessionUri;
    final File downloadFile =
        new File('${Directory.systemTemp.path}/$chave.png');

    StorageFileDownloadTask dTask = sRef.writeToFile(downloadFile);
    int byteCount = (await dTask.future).totalByteCount;
    return downloadUrl.toString();
  }

  static Future<File> colheVideo(ImageSource fonteImagem) async {
    return await ImagePicker.pickVideo(source: fonteImagem);
  }

  static Future<File> colheImagem(ImageSource fonteImagem) async {
    return await ImagePicker.pickImage(source: fonteImagem);
    // await ImagePicker.pickImage(source: fonteImagem).then((File imagem) async {
    //   if (imagem == null) return;

    //   // Mensagem linkMsg = criarMensagem(
    //   //     Usuarios.logado(), 'carregando arquivo...', DateTime.now());
    //   // salvarMensagem(linkMsg);

    //   // DatabaseReference ref =
    //   //     Banco.ref().child('anexos').child(widget.pacienteKey);
    //   // String chave = ref.push().key;

    //   // StorageReference sRef =
    //   //     FirebaseStorage.instance.ref().child('anexos').child('$chave.png');

    //   // final File arquivo =
    //   //     await new File('${Directory.systemTemp.path}/$chave.png').create();

    //   List<int> imagemBytes = imagem.readAsBytesSync();

    //   // arquivo.writeAsBytesSync(imagemBytes);

    //   // StorageUploadTask task = sRef.putFile(arquivo);
    //   // final Uri downloadUrl = (await task.onComplete).uploadSessionUri;
    //   // final File downloadFile =
    //   //     new File('${Directory.systemTemp.path}/$chave.png');
    //   // StorageFileDownloadTask dTask = sRef.writeToFile(downloadFile);
    //   // int byteCount = (await dTask.future).totalByteCount;
    //   // print('Deu $byteCount bytes no arquivo ${downloadFile.path.toString()}');
    //   // ref.child('tamanho').set(byteCount);
    //   // ref.child('link').set(downloadUrl.toString());
    //   // ref.child('nome').set(chave);
    // }).catchError((erro) {
    //   print(erro.toString());
    // });
  }
}

enum TipoExame { ANEXO, DOCUMENTO }

enum TipoAnexo { IMAGEM, VIDEO, DOCUMENTO }
