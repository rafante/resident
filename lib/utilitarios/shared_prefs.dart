import 'package:resident/imports.dart';

class Prefs {
  static Future<Null> notificacaoPaciente(String pacienteKey) async {
    final prefs = await SharedPreferences.getInstance();
    int nots = prefs.getInt(pacienteKey);
    if (nots == null) nots = 0;
    prefs.setInt(pacienteKey, ++nots);
  }

  static Future<int> verificarNotificacoes(String pacienteKey) async {
    final prefs = await SharedPreferences.getInstance();
    int nots = prefs.getInt(pacienteKey);
    if (nots == null) nots = 0;
    return nots;
  }

  static Future<Null> lerNotificacoes(String pacienteKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(pacienteKey, 0);
  }
}
