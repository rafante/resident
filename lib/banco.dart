import 'package:firebase_database/firebase_database.dart';

class Banco{
  static Banco _instancia;
  Banco(){
    if(_instancia == null){
      _instancia = new Banco();
    }
    
  }
}