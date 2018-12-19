import 'package:resident/imports.dart';

class NavegadorAnalitico extends NavigatorObserver {
  FirebaseAnalytics analytics;
  NavegadorAnalitico({this.analytics});

  @override
  void didPush(Route route, Route previousRoute) {
    analytics.logEvent(name: 'muda_pagina');
    super.didPush(route, previousRoute);
  }
}
