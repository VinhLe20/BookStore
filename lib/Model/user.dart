import 'dart:convert';

import 'package:bookstore/Model/host.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class User {
  late String email;
  late String password;
  static String id = '';

  static String role = '';
  static String sdt = '';
  static String diachi = '';
  static bool guest = false;
  late String name;

  late String phone;
  late String address;

  User(
      {required this.email,
      required this.password,
      required this.name,
      required this.address,
      required phone});

  static Future<String> loadid(String email) async {


    final uri = Uri.parse('${Host.host}/getuser.php');

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        var user = data.where((item) => item['email'] == email).toList();
        if (user.isNotEmpty) {
          return user[0]['id'];
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<String> loadrole(String email) async {


    final uri = Uri.parse('${Host.host}/getuser.php');

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        var user = data.where((item) => item['email'] == email).toList();
        if (user.isNotEmpty) {
          return user[0]['role'];
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<String> loadoderid(String id) async {

    final uri = Uri.parse('${Host.host}/getCart.php');

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        var user = data.where((item) => item['user_id'] == id).toList();
        if (user.isNotEmpty) {
          return user[0]['id'];
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<bool> isUserIdInCart(String userId) async {

    final uri = Uri.parse('${Host.host}/getcart.php');

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        var userInCart =
            data.where((item) => item['user_id'] == userId).toList();
        return userInCart.isNotEmpty;
      } else {
        throw Exception('Failed to load cart data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
