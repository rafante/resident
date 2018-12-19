import 'imports.dart';

Future<void> main() async {
  Usuario.carregarUsuarioLocal().then((event) {
    runApp(new MaterialApp(title: 'Resident', home: new AppResident()));
  });
}

class AppResident extends StatelessWidget {
  final FirebaseMessaging mensageiro = FirebaseMessaging();
  final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    keywords: <String>[
      'hospital',
      'hospitalar',
      'médico',
      'instrumentação',
      'cirúrgico',
      'bisturi',
      'medicina',
      'estetoscópio'
    ],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  Future<Null> baner() async {
    BannerAd baner = new BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      // adUnitId: BannerAd.testAdUnitId,
      adUnitId: 'ca-app-pub-1343647000894788/4156042098',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    baner.load().then((event) {
      baner.show(anchorType: AnchorType.top);
    });
  }

  NavigatorObserver navegador() {
    return Navegador();
  }

  void notificacoes() {
    mensageiro.configure(onMessage: (Map<String, dynamic> mensagem) {
      String paciente = mensagem["data"]["paciente"];
      print('o paciente é o $paciente');
      Prefs.notificacaoPaciente(paciente);
      // if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
      //   // Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      // }
    }, onLaunch: (Map<String, dynamic> mensagem) {
      print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        // Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    }, onResume: (Map<String, dynamic> mensagem) {
      print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        // Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    });
    mensageiro.requestNotificationPermissions();
    // mensageiro.getToken().then((String token) {
    //   assert(token != null);
    //   salvarToken(token);
    // });
  }

  Future<Null> salvarToken(String token) async {
    // var tokenNode = Banco.ref().child('tokens');
    bool contem = false;
    // await tokenNode.once().then((snapshot) {
    //   Map tokens = snapshot.value;
    //   contem = tokens.containsValue(token);
    // });
    // if (!contem) {
    //   tokenNode.push().set(token);
    // }
  }

  Future<FirebaseApp> inicializarFirebaseApp(BuildContext context) async {
    String appId = Theme.of(context).platform == TargetPlatform.android
        ? '1:371558675525:android:f3f9323fc4060503'
        : '1:371558675525:ios:f3f9323fc4060503';
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'resident',
      options: FirebaseOptions(
        googleAppID: appId,
        apiKey: 'AIzaSyC9yvU5sn4h4W113fFtHbRdoPCFVAU_z9g',
        databaseURL: 'https://resident-cadu.firebaseio.com',
      ),
    );
    return app;
  }

  void permissoes(BuildContext context) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.mediaLibrary,
      PermissionGroup.photos,
      PermissionGroup.storage
    ]);

    PermissionStatus camera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    PermissionStatus mediaLibrary = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.mediaLibrary);

    PermissionStatus photos =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);

    PermissionStatus storage = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (camera.index == 1 ||
        mediaLibrary.index == 1 ||
        photos.index == 1 ||
        storage.index == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Tela.de(context).x(20.0),
                  vertical: Tela.de(context).y(20.0)),
              titlePadding: EdgeInsets.symmetric(
                  horizontal: Tela.de(context).x(20.0),
                  vertical: Tela.de(context).y(20.0)),
              children: <Widget>[
                Text('Não é possível prosseguir sem conceder as permissões'),
                RaisedButton(
                  child: Text('Ok'),
                  onPressed: () {
                    exit(0);
                  },
                )
              ],
            );
          }).then((a) {
        exit(1);
      });
    }
  }

  // List<Permissions> permissions = await Permission.getPermissionStatus(
  //     [PermissionName.Storage, PermissionName.Camera]);

  // final result = await Permission.requestPermissions(
  //     [PermissionName.Storage, PermissionName.Camera]);

  // // final result =
  // //     await Permission.requestSinglePermission(PermissionName.Calendar);

  // Permission.openSettings;
  // result.forEach((permission) {
  //   if (permission.permissionStatus.index == 1) {
  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         contentPadding: EdgeInsets.symmetric(
  //             horizontal: Tela.de(context).x(20.0),
  //             vertical: Tela.de(context).y(20.0)),
  //         titlePadding: EdgeInsets.symmetric(
  //             horizontal: Tela.de(context).x(20.0),
  //             vertical: Tela.de(context).y(20.0)),
  //         children: <Widget>[
  //           Text('Não é possível prosseguir sem conceder as permissões'),
  //           RaisedButton(
  //             child: Text('Ok'),
  //             onPressed: () {
  //               exit(0);
  //             },
  //           )
  //         ],
  //       );
  //     }).then((a) {
  //   exit(1);
  // });
  //   }
  // });
  // }

  @override
  Widget build(BuildContext context) {
    permissoes(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    inicializarFirebaseApp(context).then((FirebaseApp app) {});
    if (Theme.of(context).platform == TargetPlatform.android) {
      FirebaseAdMob.instance
          .initialize(appId: 'ca-app-pub-1343647000894788~8781257788');
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      FirebaseAdMob.instance
          .initialize(appId: 'ca-app-pub-1343647000894788~3932657414');
    }

    baner();

    notificacoes();
    // if (Usuario.logado() == null) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => BaseWindow(conteudo: LoginPage(app: app))));
    // } else if (Usuario.logado().idResidente == null ||
    //     Usuario.logado().idResidente == "") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               BaseWindow(conteudo: PerfilPage(app: app))));
    // }

    if (Usuario.eu != null && Usuario.uid == null)
      Usuario.uid = Usuario.eu['uid'];
    String rotaInicial = GruposPage.tag;
    Tag primeiraTag = Tag.GRUPO;
    if (Usuario.eu == null) {
      rotaInicial = LoginPage.tag;
      primeiraTag = Tag.LOGIN;
    } else if (Usuario.eu['idResidente'] == null ||
        Usuario.eu['idResidente'] == "") {
      rotaInicial = PerfilPage.tag;
      primeiraTag = Tag.PERFIL;
    }
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return new MaterialApp(
      title: 'Resident',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: rotaInicial,
      navigatorObservers: [
        NavegadorAnalitico(analytics: analytics),
        Navegador(context: context)
      ],
      home: new BaseWindow(conteudo: LoginPage()),
      routes: <String, WidgetBuilder>{
        LoginPage.tag: (context) => new BaseWindow(conteudo: LoginPage()),
        GruposPage.tag: (context) => new BaseWindow(conteudo: GruposPage()),
        PacientesPage.tag: (context) =>
            new BaseWindow(conteudo: PacientesPage()),
        ExamesPage.tag: (context) => new BaseWindow(conteudo: ExamesPage()),
        PacientePage.tag: (context) => new BaseWindow(conteudo: PacientePage()),
        CriarUsuarioPage.tag: (context) =>
            new BaseWindow(conteudo: CriarUsuarioPage()),
        MedicamentosPage.tag: (context) =>
            new BaseWindow(conteudo: MedicamentosPage()),
        PerfilPage.tag: (context) => new BaseWindow(conteudo: PerfilPage()),
        VisionPage.tag: (context) => new BaseWindow(conteudo: VisionPage()),
      },
    );
  }
}
