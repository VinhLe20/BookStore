import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/ResetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Verificationresetpassword extends StatefulWidget {
  final String email;
  final String password;
  const Verificationresetpassword(
      {super.key, required this.email, required this.password});

  @override
  State<Verificationresetpassword> createState() =>
      _VerificationresetpasswordState();
}

class _VerificationresetpasswordState extends State<Verificationresetpassword> {
  bool isEmailVerified = false;
  Future<void> checkregister() async {
    try {
      final response = await http.post(

        Uri.parse('http://192.168.1.12/resetpassword.php'),

        body: {
          'email': widget.email,
          'password': widget.password,
        },
      );
    } catch (e) {
      print('Đăng ký thất bại: $e');
    }
  }

  //hàm xóa tài khoản trong firebase khi ngdung đã đăng kí
  void deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
        print('Đã xóa tài khoản');
      } catch (e) {
        print('Lỗi xóa tài khoản $e');
      }
    } else {
      print('No user is currently logged in');
    }
  }

//hàm kiểm tra email đã được xác minh
  void verifyEmailAndLogin(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          setState(() {
            isEmailVerified = true;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Email chưa xác minh'),
                content:
                    const Text('Vui lòng xác minh email trước khi tiếp tục.'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      // Thực hiện hành động gửi lại email xác minh
                      Navigator.pop(context); // Đóng hộp thoại
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
   

    if (isEmailVerified) {
      deleteAccount();
      
      return Resetpassword(
        email: widget.email,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Loginscreen()));
          },
          icon: Icon(Icons.arrow_back_sharp),
        ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.jpeg",
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const Text(
                'Xác minh email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              const Text(
                'Vui lòng xác minh email của bạn trước khi tiếp tục.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Đã xác minh',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                  verifyEmailAndLogin(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
