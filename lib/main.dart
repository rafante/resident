import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:resident/entidades/banco.dart';
import 'package:resident/entidades/navegador.dart';
import 'package:resident/entidades/usuarios.dart';
import 'package:resident/paginas/base.dart';
import 'package:resident/paginas/criar_usuario_page.dart';
import 'package:resident/paginas/drawers/grupo/perfil.dart';
import 'package:resident/paginas/exames.dart';
import 'package:resident/paginas/grupos_page.dart';
import 'package:resident/paginas/login_page.dart';
import 'package:resident/paginas/medicamentos.dart';
import 'package:resident/paginas/paciente.dart';
import 'package:resident/paginas/pacientes.dart';
import 'package:resident/utilitarios/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'resident',
    options: const FirebaseOptions(
      googleAppID: '1:371558675525:android:f3f9323fc4060503',
      apiKey: 'AIzaSyC9yvU5sn4h4W113fFtHbRdoPCFVAU_z9g',
      databaseURL: 'https://resident-cadu.firebaseio.com',
    ),
  );

  runApp(new MaterialApp(title: 'Resident', home: new AppResident(app: app)));
}

class AppResident extends StatelessWidget {
  AppResident({this.app});
  final FirebaseApp app;
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
        print("BannerAd event is $event");
      },
    );
  }

  NavigatorObserver navegador() {
    return Navegador();
  }

  void notificacoes() {
    mensageiro.configure(onMessage: (Map<String, dynamic> mensagem) {
      print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    }, onLaunch: (Map<String, dynamic> mensagem) {
      print('caiu no mensageiro:\n $mensagem');
      if (mensagem.containsKey('grupo') && mensagem.containsKey('paciente')) {
        Prefs.salvarNotificacao(mensagem['grupo'], mensagem['paciente']);
      }
    }, onResume: (Map<String, dynamic> mensagem) {
      print('caiu no mensageiro:\n $mensagem');
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
    var tokenNode = Banco.ref().child('tokens');
    bool contem = false;
    await tokenNode.once().then((snapshot) {
      Map tokens = snapshot.value;
      contem = tokens.containsValue(token);
    });
    if (!contem) {
      tokenNode.push().set(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-1343647000894788~8781257788');

    // baner()
    //   ..load()
    //   ..show(anchorType: AnchorType.top, anchorOffset: 0.0);

    //notificacoes();
    return new MaterialApp(
      title: 'Resident',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BaseWindow(conteudo: GruposPage(app: app)),
      routes: <String, WidgetBuilder>{
        LoginPage.tag: (context) =>
            new BaseWindow(conteudo: LoginPage(app: app)),
        GruposPage.tag: (context) =>
            new BaseWindow(conteudo: GruposPage(app: app)),
        PacientesPage.tag: (context) =>
            new BaseWindow(conteudo: PacientesPage(app: app)),
        ExamesPage.tag: (context) =>
            new BaseWindow(conteudo: ExamesPage(app: app)),
        PacientePage.tag: (context) =>
            new BaseWindow(conteudo: PacientePage(app: app)),
        CriarUsuarioPage.tag: (context) =>
            new BaseWindow(conteudo: CriarUsuarioPage(app: app)),
        MedicamentosPage.tag: (context) =>
            new BaseWindow(conteudo: MedicamentosPage(app: app))
      },
    );
  }
}
