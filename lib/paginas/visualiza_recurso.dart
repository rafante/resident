import 'package:resident/imports.dart';

class VisualizaRecurso extends StatefulWidget {
  VisualizaRecurso({this.link});
  final String link;
  _VisualizaRecursoState createState() => _VisualizaRecursoState();
}

class _VisualizaRecursoState extends State<VisualizaRecurso> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(new File(widget.link)),
    );
  }
}
