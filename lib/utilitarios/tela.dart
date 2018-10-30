import 'package:flutter/material.dart';

class Tela {
  static double xPixs(BuildContext context, double valor) {
    double largura = MediaQuery.of(context).size.width;
    return largura * valor / 100;
  }

  static double yPics(BuildContext context, double valor) {
    double altura = MediaQuery.of(context).size.height;
    return altura * valor / 100;
  }
}
