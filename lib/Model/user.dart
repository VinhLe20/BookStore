import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class User {
  late String email;
  late String password;
  static String id = '';
  static String order_id = '';

  User({required this.email, required this.password});

  static Future<String> loadid(String email) async {
    final uri = Uri.parse('http://192.168.1.10/getuser.php');
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

  static Future<String> loadoderid(String id) async {
    final uri = Uri.parse('http://192.168.1.10/getCart.php');
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
    final uri = Uri.parse('http://192.168.1.10/getcart.php');
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