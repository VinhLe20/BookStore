import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/ResetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  const VerificationScreen(
      {super.key, required this.email, required this.password});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isEmailVerified = false;
  Future<void> checkregister() async {
    try {
      final response = await http.post(
        Uri.parse('${Host.host}/register.php'),
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
            checkregister();
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
      return Loginscreen();
    } else {
      return Scaffold(
        body: Stack(
          children: [
            const Image(
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              image: AssetImage('assets/images/welcome.png'),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginscreen(),
                        ),
                      );
                    },
                    icon:
                        const Icon(Icons.arrow_back_sharp, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Xác minh email',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.mail_outline_outlined,
                                  size: 40, color: Colors.white)
                            ],
                          ),
                          SizedBox(height: 16),
                          const Text(
                            'Vui lòng xác minh email của bạn trước khi tiếp tục.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 32),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Đã xác minh',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
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
                                    return Colors
                                        .white; // Màu nền button khi được nhấn
                                  }
                                  return Colors.red
                                      .shade500; // Sử dụng màu nền mặc định (red.500)
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return null; // Màu chữ button khi được nhấn
                                  }
                                  return Colors
                                      .white; // Sử dụng màu chữ mặc định (white)
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
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
