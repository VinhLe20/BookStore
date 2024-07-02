import 'package:firebase_database/firebase_database.dart';

class User1 {
  late String email;
  late String password;
  User1({required this.email, required this.password});
  Future<void> load(String? _email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('BookStore');
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    Map map = snapshot.value as Map;
    map.forEach((key, value) {
      if (_email == value['email']) {
        email = value['email'];
        password = value['password'];
      }
    });
  }
}
