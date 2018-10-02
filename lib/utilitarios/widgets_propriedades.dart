import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resident/utilitarios/widgets_basicos.dart';

class PropriedadesWidget{

  static PropriedadesWidget novo(){
    return new PropriedadesWidget();
  }

  bool autocorrect = false;
  bool autofocus = false;
  bool autovalidate = false;
  TextEditingController controller = TextEditingController(text: '');
  String hintText;
  TipoBorda tipoBorda = TipoBorda.NENHUMA;
  BorderStyle borderStyle;
  double borderWidth;
  bool enabled = true;
  Color borderColor;
  double borderRadius;
  double gapPadding;
  double fontSize;
  FocusNode focusNode;
  bool filledBorder = false;
  TextStyle hintStyle;
  String initialValue;
  List<TextInputFormatter> inputFormatters;
  Key key;
  EdgeInsets padding = EdgeInsets.zero;
  Brightness keyboardAppearance;
  TextInputType keyboardType;
  int maxLength;
  bool maxLengthEnforced = false;
  int maxLines;
  double fieldHeight = 1.0;
  bool obscureText = false;
  Function onEditingComplete;
  Function onFieldSubmitted;
  Function onSaved;
  EdgeInsets scrollPadding = EdgeInsets.zero;
  TextStyle style;
  Color fontColor = Colors.black;
  FontStyle fontStyle = FontStyle.normal;
  FontWeight fontWeigth = FontWeight.normal;
  double letterSpacing;
  Locale locale = Locale("pt-BR");
  TextAlign textAlign = TextAlign.left;
  TextCapitalization textCapitalization = TextCapitalization.none;
  TextInputAction textInputAction;
  Function validator;
}