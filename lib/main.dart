import 'imports.dart';

Future<void> main() async {
  runApp(new MaterialApp(title: 'Resident', home: new AppResident()));
}

class AppResident extends StatelessWidget {
  bool firstTime = true;
  final FirebaseMessaging mensageiro = FirebaseMessaging();

  MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
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
    birthday: new DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender:
        MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd baner() {
    return new BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      // adUnitId: 'ca-app-pub-1343647000894788/4156042098',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        // print("BannerAd event is $event");
      },
    );
  }

  NavigatorObserver navegador() {
    return Navegador();
  }

  void notificacoes() {
    mensageiro.configure(onMessage: (Map<String, dynamic> mensagem) {
      // print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    }, onLaunch: (Map<String, dynamic> mensagem) {
      // print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    }, onResume: (Map<String, dynamic> mensagem) {
      // print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    });
    mensageiro.requestNotificationPermissions();
    mensageiro.subscribeToTopic('paciente');
    mensageiro.getToken().then((String token) {
      assert(token != null);
      salvarToken(token);
    });
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

  @override
  Widget build(BuildContext context) {
    inicializarFirebaseApp(context).then((FirebaseApp app) {});
    if (Theme.of(context).platform == TargetPlatform.android) {
      FirebaseAdMob.instance
          .initialize(appId: 'ca-app-pub-1343647000894788~8781257788');
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      FirebaseAdMob.instance
          .initialize(appId: 'ca-app-pub-1343647000894788~3932657414');
    }
    // baner()
    //   ..load()
    //   ..show(anchorType: AnchorType.top, anchorOffset: 0.0);

    //notificacoes();
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

    String rotaInicial = GruposPage.tag;
    if (Usuario.eu == null) {
      rotaInicial = LoginPage.tag;
    } else if (Usuario.eu['idResidente'] == null ||
        Usuario.eu['idResidente'] == "") {
      rotaInicial = PerfilPage.tag;
    }

    return new MaterialApp(
      title: 'Resident',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: rotaInicial,
      home: new BaseWindow(conteudo: HomePage()),
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
