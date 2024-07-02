import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController _usercontroller = TextEditingController();
  void printNewPassword(String newPassword) {
    print('Mật khẩu mới: $newPassword');
  }

  void updatePasswordInRealtimeDatabase(String userId, String newPassword) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.child('users').update({
      'password': newPassword,
    }).then((_) {
      print(
          'Mật khẩu mới đã được cập nhật thành công trong Firebase Realtime Database');
    }).catchError((error) {
      print(
          'Lỗi khi cập nhật mật khẩu mới trong Firebase Realtime Database: $error');
    });
  }

  void getNewPasswordFromRealtimeDatabase(String userId) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference
        .child('users')
        .child('password')
        .once()
        .then((DataSnapshot snapshot) {
          final newPassword = snapshot.value as String;
          print('Mật khẩu mới từ Firebase Realtime Database: $newPassword');
        } as FutureOr Function(DatabaseEvent value))
        .catchError((error) {
      print('Lỗi khi đọc mật khẩu mới từ Firebase Realtime Database: $error');
    });
  }

  void resetPassword1(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Email đặt lại mật khẩu đã được gửi thành công');

      // Lấy mật khẩu mới từ người dùng
      String newPassword =
          'your_new_password'; // Thay thế bằng cách lấy mật khẩu mới từ người dùng

      // In mật khẩu mới ra terminal
      printNewPassword(newPassword);
    } catch (e) {
      print('Lỗi khi gửi email đặt lại mật khẩu: $e');
    }
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Email đặt lại mật khẩu đã được gửi thành công');
    } catch (e) {
      print('Lỗi khi gửi email đặt lại mật khẩu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.jpeg",
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              TextFormField(
                controller: _usercontroller,
                decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _usercontroller.clear();
                        },
                        icon: Icon(Icons.close_rounded))),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Colors.black, width: 1)),
                        minimumSize: Size(double.infinity, 70))
                    .copyWith(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white; // Màu nền button khi được nhấn
                      }
                      return Colors
                          .red.shade500; // Sử dụng màu nền mặc định (red.500)
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return null; // Màu chữ button khi được nhấn
                      }
                      return Colors.white; // Sử dụng màu chữ mặc định (white)
                    },
                  ),
                ),
                onPressed: () {
                  resetPassword1(_usercontroller.text);
                  updatePasswordInRealtimeDatabase(
                      _usercontroller.text, 'newPassword');
                  getNewPasswordFromRealtimeDatabase(_usercontroller.text);
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
