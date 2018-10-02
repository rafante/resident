import 'package:flutter/material.dart';
import 'package:resident/utilitarios/widgets_propriedades.dart';

abstract class InputBasico {

  PropriedadesWidget props;
  InputBasico(){
    props = PropriedadesWidget.novo();
  }
  Widget getFormField();

  Widget fim() {
    if (props.padding != EdgeInsets.zero) {
      return Padding(
        padding: props.padding,
        child: getFormField(),
      );
    } else {
      return getFormField();
    }
  }

  InputBasico autoCorrigir(bool auto) {
    props.autocorrect = auto;
    return this;
  }

  InputBasico aoSelecionar(Function funcaoSelecao){
    props.onEditingComplete = funcaoSelecao;
    return this;
  }

  InputBasico autoFocar(bool auto) {
    props.autofocus = auto;
    return this;
  }

  InputBasico autoValidar(bool auto) {
    props.autovalidate = auto;
    return this;
  }

  InputBasico valorInicial(String valorInicial) {
    props.controller.text = valorInicial;
    return this;
  }

  InputBasico alinhar(TextAlign alinhamento) {
    props.textAlign = alinhamento;
    return this;
  }

  InputBasico tamanhoDaLetra(double tamanho) {
    props.fontSize = tamanho;
    return this;
  }

  InputBasico dicaTexto(String dica) {
    props.hintText = dica;
    return this;
  }

  InputBasico espacamento(double horizontal, double vertical) {
    return espacamentoCompleto(horizontal, vertical, horizontal, vertical);
  }

  InputBasico espacamentoCompleto(
      double esquerda, double direita, double cima, double baixo) {
    props.padding = EdgeInsets.fromLTRB(esquerda, cima, direita, baixo);
    return this;
  }

  InputBasico cor(Color cor) {
    props.fontColor = cor;
    return this;
  }

  InputBasico alturaCampo(double altura) {
    props.fieldHeight = altura;
    return this;
  }

  InputBasico bordaDeContorno(double raio, Color cor, BorderStyle estiloBorda,
      double largura, double lacuna) {
    props.tipoBorda = TipoBorda.OUTLINE;
    props.borderRadius = raio;
    props.borderColor = cor;
    props.borderStyle = estiloBorda;
    props.borderWidth = largura;
    props.gapPadding = lacuna;
    return this;
  }

  InputBasico bordaSublinhada(double raio, Color cor, BorderStyle estiloBorda,
      double largura, double lacuna) {
    props.tipoBorda = TipoBorda.UNDERLINE;
    props.borderRadius = raio;
    props.borderColor = cor;
    props.borderStyle = estiloBorda;
    props.borderWidth = largura;
    props.gapPadding = lacuna;
    return this;
  }

  InputBasico semBorda() {
    props.tipoBorda = TipoBorda.NENHUMA;
    return this;
  }
}

enum TipoBorda { NENHUMA, OUTLINE, UNDERLINE }