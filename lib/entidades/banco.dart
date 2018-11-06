import 'package:firebase_database/firebase_database.dart';

class Banco {
  static bool _firstTime = true;

  static void setup() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  static DatabaseReference ref() {
    if (_firstTime) {
      setup();
      _firstTime = false;
    }
    return FirebaseDatabase.instance.reference();
  }
}
