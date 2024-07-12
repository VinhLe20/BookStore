import 'package:bookstore/Views/VerificationEditPassword.dart';
import 'package:bookstore/Views/VerificationResetPassword.dart';
import 'package:bookstore/Views/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Editpassword extends StatefulWidget {
  const Editpassword({super.key});

  @override
  State<Editpassword> createState() => _EditpasswordState();
}

class _EditpasswordState extends State<Editpassword> {
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
                title: const Text('Email chưa xác minh'),
                content:
                    const Text('Vui lòng xác minh email trước khi tiếp tục.'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      // Thực hiện hành động gửi lại email xác minh
                      if (user!.emailVerified) {
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Verificationeditpassword(email: _usercontroller.text, password: '')),
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
                        builder: (context) =>  Index(selectedIndex: 2,),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_sharp, color: Colors.white),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Cập nhật mật khẩu",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _usercontroller,
                          onChanged: (_) => validateEmail(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: const TextStyle(color: Colors.white),
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
                            errorStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _usercontroller.clear();
                              },
                              icon: const Icon(Icons.close_rounded,color: Colors.white,),
                            ),
                          ),
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
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                            minimumSize: const Size(double.infinity, 70),
                          ),
                          onPressed: () async {
                            validateEmail();
                            if (_userError.isEmpty) {
                              registerUser();
                              verifyEmailAndLogin(context);
                            }
                          },
                          child: const Text(
                            'Cập nhật',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
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