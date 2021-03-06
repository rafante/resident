import 'package:resident/imports.dart';

class Exame {
  String key;
  String pacienteKey;
  String descricao;
  String nome;
  String anexo;
  String extensao;
  String downloadLink;
  int tamanho;

  Exame(
      {this.descricao,
      this.nome,
      this.downloadLink,
      this.tamanho,
      this.key,
      this.pacienteKey,
      this.extensao,
      this.anexo});

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

  static Future<File> _downloadFile(
      String anexoName, String anexoExtensao) async {
    return DownloadUpload.download('anexos', '$anexoName.$anexoExtensao');
    // StorageReference ref = FirebaseStorage.instance
    //     .ref()
    //     .child('anexos')
    //     .child('$anexoName.$anexoExtensao');
    // print('o Arquivo -> $anexoName.$anexoExtensao');
    // var uri = await ref.getDownloadURL();
    // final http.Response downloadData = await http.get(uri).catchError((erro) {
    //   print(erro);
    //   return null;
    // });
    // Directory tempDir = await getTemporaryDirectory();
    // String tempPath = tempDir.path;
    // final File tempFile = File('$tempPath/$anexoName.$anexoExtensao');
    // if (tempFile.existsSync()) {
    //   await tempFile.delete();
    // }
    // await tempFile.create();
    // assert(await tempFile.readAsString() == "");
    // tempFile.writeAsBytesSync(downloadData.bodyBytes);
    // final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    // final int byteCount = (await task.future).totalByteCount;
    // final List<int> tempFileContents = await tempFile.readAsBytesSync();
    // tempFile.writeAsBytesSync(tempFileContents);
  }

  static Future<Null> abrirAnexoExame(BuildContext context,
      {Exame exame, String ExameId}) async {
    if (exame == null) {
      print('exame veio nulo, carregando do banco');
      await Firestore.instance
          .document('exames/$ExameId')
          .snapshots()
          .first
          .then((documento) {
        exame = Exame(
            nome: documento.data['nome'],
            tamanho: documento.data['tamanho'],
            anexo: documento.data['anexo'],
            extensao: documento.data['extensao'],
            pacienteKey: documento.data['pacienteKey'],
            key: documento.data['key'],
            descricao: documento.data['descricao'],
            downloadLink: documento.data['downloadLink']);
      });
    }
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String path = '$tempPath/${exame.anexo}.${exame.extensao}';
    File file = new File(path);
    if (file.existsSync() && file.lengthSync() == exame.tamanho) {
      OpenFile.open(path);
      // Navegador.de(context).navegar(Tag.VISUALIZA_RECURSO, {'link': path});
    } else {
      await _downloadFile(exame.anexo, exame.extensao);
      OpenFile.open(path);
    }
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
          file = await popupInsereDocumentoExame(context,
              pacienteKey: pacienteKey);
          break;
      }
      if (file == null) return;

      final Mensagem mensagem =
          await Mensagem.criar(pacienteKey, texto: 'Inserindo anexo... (0%)');
      await upload(file, pacienteKey, mensagem);

      // Fluttertoast.showToast(
      //   msg: "Exame inserido",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIos: 1,
      //   bgcolor: "#e74c3c",
      // );
      // textcolor: '#ffffff');
    }
  }

  static Future<File> popupInsereDocumentoExame(BuildContext context,
      {String pacienteKey,
      String documentID,
      String nome = '',
      String descricao = ''}) async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return null;
      }
      return new File(filePath);
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
    return null;
  }

  static Future<Null> popupInsereDocumentoExame1(BuildContext context,
      {String pacienteKey,
      String documentID,
      String nome = '',
      String descricao = ''}) async {
    TextEditingController nomeController = TextEditingController(text: nome);
    TextEditingController descricaoController =
        TextEditingController(text: descricao);

    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Exame 2'),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Tela.de(context).x(20.0),
                  vertical: Tela.de(context).y(10.0)),
              child: TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  hintText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Tela.de(context).x(20.0),
                  vertical: Tela.de(context).y(10.0)),
              child: TextFormField(
                controller: descricaoController,
                maxLines: 10,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () async {
                DocumentReference exameRef;
                if (documentID == null)
                  exameRef = Firestore.instance.collection('exames').document();
                else
                  exameRef = Firestore.instance.document('exames/$documentID');

                await exameRef.setData({
                  'nome': nomeController.text,
                  'pacienteKey': pacienteKey,
                  'anexo': null,
                  'key': exameRef.documentID,
                  'extensao': 'doc',
                  'descricao': descricaoController.text,
                  'tamanho': nomeController.text.length +
                      descricaoController.text.length,
                  'downloadLink': null,
                }); //
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static Future<String> upload(
      File file, String pacienteKey, Mensagem mensagem) async {
    if (file == null) return null;
    String extensao = file.path.split('.').last;
    DocumentReference exameRef =
        Firestore.instance.collection('exames').document();

    String chave = exameRef.documentID;
    StorageReference sRef = FirebaseStorage.instance
        .ref()
        .child('anexos')
        .child('$chave.$extensao');
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    final File arquivo = new File('$tempPath/$chave.$extensao');

    bool erro = false;
    await arquivo.create().catchError((erro) {
      // Fluttertoast.showToast(
      //   msg: erro.toString(),
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIos: 1,
      //   bgcolor: "#e74c3c",
      // );
      mensagem.deletar();
    });

    if (!erro) {
      List<int> imagemBytes = file.readAsBytesSync();
      arquivo.writeAsBytesSync(imagemBytes);

      StorageUploadTask task = sRef.putFile(arquivo);
      task.events.listen((evento) async {
        String texto = '';
        switch (evento.type) {
          case StorageTaskEventType.progress:
            int bytes = evento.snapshot.bytesTransferred;
            double porcentagem = (bytes * 100) / imagemBytes.length;
            texto = 'Inserindo anexo... (${porcentagem.toInt()}%)';
            break;
          case StorageTaskEventType.failure:
            texto = 'upload falhou';
            break;
          case StorageTaskEventType.pause:
            texto = 'upload pausado';
            break;
          case StorageTaskEventType.resume:
            texto = 'pausa no upload removida';
            break;
          case StorageTaskEventType.success:
            mensagem.setar(pacienteKey: pacienteKey, link: chave, texto: texto);
            texto = 'Anexo inserido';
            break;
        }

        mensagem.setar(pacienteKey: pacienteKey, texto: texto);
        await mensagem.salvar();
      });

      final Uri downloadUrl = (await task.onComplete).uploadSessionUri;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      final File downloadFile = new File('$tempPath/$chave.$extensao');

      StorageFileDownloadTask dTask = sRef.writeToFile(downloadFile);
      FileDownloadTaskSnapshot downloadSnap = await dTask.future;

      await exameRef.setData({
        'nome': 'Anexo',
        'pacienteKey': pacienteKey,
        'anexo': chave,
        'extensao': extensao,
        'descricao': 'Anexo',
        'tamanho': imagemBytes.length,
        'downloadLink': downloadUrl.toString(),
      });

      return downloadUrl.toString();
    }
    return null;
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
