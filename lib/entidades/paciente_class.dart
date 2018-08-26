import 'package:firebase_database/firebase_database.dart';

class Paciente {
  String nome;
  String key;
  DatabaseReference ref;

  Paciente({this.key, this.nome}) {
    if (ref == null) ref = FirebaseDatabase.instance.reference();
    if (key == null || key == "") {
      nome = "";
      key = ref.child('pacientes').push().key;
    }else{
      ref.child('pacientes').child(key).once().then((snapshot){
        Map paciente = snapshot.value;
        nome = paciente['nome'];

      });
    }
  }
}
