import 'dart:async';

import 'package:bookstore/Views/ResetPassword.dart';
import 'package:bookstore/Views/VerificationResetPassword.dart';
import 'package:bookstore/Views/VerificationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Forgotpassword extends StatefulWidget {
  const Forgotpassword(
      {super.key, required String email, required String password});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController _usercontroller = TextEditingController();
  String _userError = '';
  //hàm kiểm tra email
  void validateEmail() {
    setState(() {
      final email = _usercontroller.text.trim();
      if (email.isEmpty) {
        _userError = 'Email không được bỏ trống';
      } else if (!_isValidEmail(email)) {
        _userError = 'Email không hợp lệ';
      } else {
        _userError = '';
      }
    });
  }

  bool _isValidEmail(String email) {
    // Biểu thức chính quy để kiểm tra định dạng email
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

//gửi email từ firebase
  void registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _usercontroller.text, password: '123456@123');

      await userCredential.user?.sendEmailVerification();

      print('Đã gửi email ');
      verifyEmailAndLogin(context);
    } catch (e) {
      print('Không gửi được email $e');
    }
  }

  //hàm kiểm tra email khi ngdung nhấn vào link
  void verifyEmailAndLogin(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        {
          // Hiển thị thông báo cho người dùng
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email chưa xác minh'),
                content: Text('Vui lòng xác minh email trước khi tiếp tục.'),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      // Thực hiện hành động gửi lại email xác minh
                      if (user!.emailVerified) {
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Verificationresetpassword(email:_usercontroller.text,password: '',)),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error verifying email: $e');
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
                onChanged: (_) => validateEmail(),
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
                    errorText: _userError.isNotEmpty ? _userError : null,
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
                onPressed: () async {
                  validateEmail();
                  if (_userError.isEmpty) {
                    registerUser();
                    verifyEmailAndLogin(context);
                  }
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
