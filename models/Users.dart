import 'package:firebase_auth/firebase_auth.dart';

class Users {
  final String name;
  final String email;
  final String password;
  Users({required this.name, required this.email, required this.password});
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
