import 'package:resident/imports.dart';

class Tela {
  static const double _larguraPadrao = 423.5294196844927;
  static const double _alturaPadrao = 752.9411905502093;
  static const double _fatorPadrao = _larguraPadrao * _alturaPadrao;

  BuildContext _context;
  double _fator;

  Tela({BuildContext context}) {
    this._context = context;
    _fator =
        MediaQuery.of(context).size.width * MediaQuery.of(context).size.height;
  }
  static Tela de(BuildContext context) {
    return Tela(context: context);
  }

  double x(double ref) {
    return MediaQuery.of(_context).size.width / _larguraPadrao * ref;
  }

  double y(double ref) {
    return MediaQuery.of(_context).size.height / _alturaPadrao * ref;
  }

  double abs(double ref) {
    return _fator / _fatorPadrao * ref;
  }
}
