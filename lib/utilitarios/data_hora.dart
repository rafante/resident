import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resident/utilitarios/input_texto.dart';

class DataHora extends InputTexto {
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  DateTime selecionada;

  static DataHora criar() {
    return new DataHora();
  }

  DataHora padrao1() {
    return DataHora.criar()
        .tamanhoDaLetra(30.0)
        .cor(Colors.black)
        .espacamento(20.0, 20.0)
        .bordaDeContorno(5.0, Colors.black, BorderStyle.solid, 10.0, 15.0);
  }

  @override
  Widget getFormField() {
    return DateTimePickerFormField(
        format: dateFormat,
        autocorrect: props.autocorrect,
        autofocus: props.autofocus,
        autovalidate: props.autovalidate,
        controller: props.controller,
        decoration: super.getDecoration(),
        enabled: props.enabled,
        focusNode: props.focusNode,
        inputFormatters: props.inputFormatters,
        key: props.key,
        keyboardType: props.keyboardType,
        maxLength: props.maxLength,
        maxLengthEnforced: props.maxLengthEnforced,
        maxLines: props.maxLines,
        obscureText: props.obscureText,
        onChanged: (DateTime data){
          this.selecionada = data;
          if(props.onEditingComplete != null)
            props.onEditingComplete();
        },
        onFieldSubmitted: props.onFieldSubmitted,
        onSaved: props.onSaved,
        style: TextStyle(
            color: props.fontColor,
            fontSize: props.fontSize,
            fontStyle: props.fontStyle,
            fontWeight: props.fontWeigth,
            letterSpacing: props.letterSpacing,
            height: props.fieldHeight,
            locale: props.locale),
        textAlign: props.textAlign,
        validator: props.validator);
  }
}