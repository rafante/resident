import 'package:flutter/material.dart';
import 'package:resident/utilitarios/widgets_basicos.dart';

class InputTexto extends InputBasico {
  String digitado;

  InputTexto();

  static InputTexto criar() {
    return new InputTexto();
  }

  OutlineInputBorder getOutline() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(props.borderRadius)),
        borderSide: BorderSide(
            color: props.borderColor, style: props.borderStyle, width: props.borderWidth),
        gapPadding: props.gapPadding);
  }

  UnderlineInputBorder getUnderline() {
    return UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(props.borderRadius)),
        borderSide: BorderSide(
            color: props.borderColor, style: props.borderStyle, width: props.borderWidth));
  }

  InputDecoration getDecoration() {
    return InputDecoration(
        border: props.tipoBorda == TipoBorda.NENHUMA
            ? null
            : props.tipoBorda == TipoBorda.OUTLINE ? getOutline() : getUnderline(),
        contentPadding: EdgeInsets.all(props.gapPadding),
        fillColor: props.borderColor,
        filled: props.filledBorder,
        hintText: props.hintText,
        hintStyle: props.hintStyle);
  }

  InputTexto padrao1() {
    return InputTexto.criar()
        .tamanhoDaLetra(30.0)
        .cor(Colors.black)
        .espacamento(20.0, 20.0)
        .bordaDeContorno(5.0, Colors.black, BorderStyle.solid, 10.0, 15.0);
  }

  InputTexto tipoTelefone(){
    props.keyboardType = TextInputType.phone;
    return this;
  }

  InputTexto tipoEmail(){
    props.keyboardType = TextInputType.emailAddress;
    return this;
  }

  InputTexto tipoNumero(){
    props.keyboardType = TextInputType.number;
    return this;
  }

  Widget getFormField() {
    return TextFormField(
        autocorrect: props.autocorrect,
        autofocus: props.autofocus,
        autovalidate: props.autovalidate,
        controller: props.controller,
        decoration: getDecoration(),
        enabled: props.enabled,
        focusNode: props.focusNode,
        initialValue: props.initialValue,
        inputFormatters: props.inputFormatters,
        key: props.key,
        keyboardAppearance: props.keyboardAppearance,
        keyboardType: props.keyboardType,
        maxLength: props.maxLength,
        maxLengthEnforced: props.maxLengthEnforced,
        maxLines: props.maxLines,
        obscureText: props.obscureText,
        onEditingComplete: (){
          digitado = props.controller.text;
          if(props.onEditingComplete != null)
            props.onEditingComplete();
        },
        onFieldSubmitted: props.onFieldSubmitted,
        onSaved: props.onSaved,
        scrollPadding: props.scrollPadding,
        style: TextStyle(
            color: props.fontColor,
            fontSize: props.fontSize,
            fontStyle: props.fontStyle,
            fontWeight: props.fontWeigth,
            letterSpacing: props.letterSpacing,
            height: props.fieldHeight,
            locale: props.locale),
        textAlign: props.textAlign,
        textCapitalization: props.textCapitalization,
        textInputAction: props.textInputAction,
        validator: props.validator);
  }
}