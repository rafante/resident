import 'package:resident/imports.dart';

class Navegador extends NavigatorObserver {
  BuildContext context;
  static List<Tag> caminho = [];
  static Tag tagAnterior = Tag.LOGIN;
  static Tag tagAtual = Tag.LOGIN;
  static Tag proximaTag = Tag.LOGIN;
  static StatefulWidget conteudo;

  Navegador({this.context});

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
  }

  static Navegador de(BuildContext context) {
    return Navegador(context: context);
  }

  static void voltar1(BuildContext context){
    if(tagAtual != Tag.LOGIN && tagAtual != Tag.GRUPOS)
      Navigator.pop(context);
  }

  Future<Null> navegar1(Tag proxima, Map args) {
    if(args == null)
    args = {};
    Tag interceptada = intercept(proxima);
    proxima = interceptada;
    tagAnterior = proxima;
    conteudo = getConteudo(proxima, args);
    return Navigator.of(context) 
        .push(MaterialPageRoute(builder: (BuildContext cont) {
      return BaseWindow(conteudo: conteudo, popScope: args['popScope'],);
    }));
  }

  Tag intercept(Tag proxima) {
    if (Usuario.uid == null || Usuario.eu == null) {
      if (tagAtual != Tag.LOGIN) 
      return Tag.LOGIN;
    } else if (Usuario.eu['idResidente'] == null ||
        Usuario.eu['idResidente'] == "" ||
        Usuario.eu['telefone'] == null ||
        Usuario.eu['telefone'] == "") {
      return Tag.PERFIL;
    }
    return proxima;
  }

  Widget getConteudo(Tag proxima Map argumentos) {
    Widget conteudo;
    if(argumentos == null){
      argumentos = {
        'grupoChave':null,
        'key':null,
        'title':null,
        'grupoKey':null,
        'pacienteKey':null,
        'medicamentoKey':null,
      };
    }
    // if (proxima != tagAtual) {
      switch (proxima) {
        case Tag.LOGIN:
          conteudo = LoginPage();
          break;
        case Tag.PERFIL:
          conteudo = PerfilPage();
          break;
        case Tag.CONTATOS:
          conteudo = ContatosPage();
          break;
        case Tag.PREMIUM:
          conteudo = PremiumPage();
          break;
        case Tag.GRUPOS:
          conteudo = GruposPage();
          break;
        case Tag.GRUPO_DETALHE:
          conteudo = DadosGrupoPage(grupoChave: argumentos['grupoChave']);
          break;
        case Tag.GRUPO:
          conteudo =
              GruposPage(key: argumentos['key'], title: argumentos['title']);
          break;
        case Tag.PACIENTES:
          conteudo = PacientesPage(grupoKey: argumentos['grupoKey']);
          break;
        case Tag.PACIENTE_DETALHE:
          conteudo = PacienteDetalhe(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.PACIENTE:
          conteudo = PacientePage(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.EXAMES:
          conteudo = ExamesPage(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey'],
              pacienteNome: argumentos['pacienteNome']);
          break;
        case Tag.MEDICAMENTOS:
          conteudo = MedicamentosPage(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.MEDICAMENTO_DETALHE:
          conteudo = MedicamentoDetalhe(
              medicamentoKey: argumentos['medicamentoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.HISTORIA_DOENCA_ATUAL:
          conteudo = HistoriaDoencaAtualPage(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.HISTORIA_PREGRESSA:
          conteudo = HistoriaPregressaPage(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.HIPOTESE_DIAGNOSTICA:
          conteudo = HipoteseDiagnosticaPage(
              grupoKey: argumentos['grupoKey'],
              pacienteKey: argumentos['pacienteKey']);
          break;
        case Tag.ALTA_PACIENTE:
          break;
          case Tag.VISUALIZA_RECURSO:
          conteudo = VisualizaRecurso(link: argumentos['link']);
          break;
      }
    // }
    return conteudo;
  }
}

enum Tag {
  LOGIN,
  PERFIL,
  CONTATOS,
  PREMIUM,
  GRUPOS,
  GRUPO_DETALHE,
  GRUPO,
  PACIENTES,
  PACIENTE_DETALHE,
  PACIENTE,
  EXAMES,
  MEDICAMENTOS,
  MEDICAMENTO_DETALHE,
  HISTORIA_DOENCA_ATUAL,
  HISTORIA_PREGRESSA,
  HIPOTESE_DIAGNOSTICA,
  ALTA_PACIENTE,
  VISUALIZA_RECURSO
}
