import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<Null> salvarNotificacao(
      String grupoKey, String pacienteKey) async {
    final prefs = await SharedPreferences.getInstance();
    String grupo = grupoKey;
    String paciente = grupoKey + '|' + pacienteKey;
    int grupoNots = prefs.getInt(grupo);
    if(grupoNots == null)
      grupoNots = 0;
    int pacienteNots = prefs.getInt(paciente);
    if(pacienteNots == null)
      pacienteNots = 0;
    prefs.setInt(paciente, ++pacienteNots);
    prefs.setInt(grupo, ++grupoNots);
  }

  static Future<Null> lerNotificacao(
      String grupoKey, String pacienteKey) async {
    final prefs = await SharedPreferences.getInstance();
    String grupo = grupoKey;
    String paciente = grupoKey + '|' + pacienteKey;
    prefs.setInt(paciente, 0);
    prefs.setInt(grupo, 0);
  }

  static Future<int> checarNotificacoes({String grupo, String paciente = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    print('checando notificações para o grupo: $grupo paciente: $paciente');
    var chave = grupo;
    if(paciente != ""){
      chave += "|" + paciente;
    }
    var nots = await prefs.getInt(chave);
    if(nots == null)
      nots = 0;
    print('número de notificações: $nots');
    return nots;
  }
}
