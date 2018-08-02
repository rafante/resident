import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:resident/criar_usuario_page.dart';
import 'package:resident/grupos_page.dart';
import 'package:resident/login_page.dart';
import 'package:resident/paciente.dart';
import 'package:resident/pacientes.dart';
import 'package:resident/usuarios.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'resident',
    options: const FirebaseOptions(
      googleAppID: '1:371558675525:android:f3f9323fc4060503',
      apiKey: 'AIzaSyC9yvU5sn4h4W113fFtHbRdoPCFVAU_z9g',
      databaseURL: 'https://resident-cadu.firebaseio.com',
    ),
  );
  runApp(new MaterialApp(
    title: 'Resident',
    home: new MyApp(app: app),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.app});
  final FirebaseApp app;

  MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
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
      adUnitId: 'ca-app-pub-1343647000894788/4156042098',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-1343647000894788~8781257788');

    baner()
      ..load()
      ..show(anchorType: AnchorType.top, anchorOffset: 0.0);
    Usuarios.logado();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
      title: 'Resident',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GruposPage(app: app),
      routes: <String, WidgetBuilder>{
        LoginPage.tag: (context) => LoginPage(app: app),
        GruposPage.tag: (context) => GruposPage(app: app),
        PacientesPage.tag: (context) => PacientesPage(app: app),
        PacientePage.tag: (context) => PacientePage(app: app),
        CriarUsuarioPage.tag: (context) => CriarUsuarioPage(app: app)
      },
    );
  }
}
