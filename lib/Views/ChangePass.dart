import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/index.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Changepass extends StatefulWidget {
  final String email;

  const Changepass({super.key, required this.email});
  @override
  State<Changepass> createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  final _passwordcontroller = TextEditingController();
  final _repasswordcontroller = TextEditingController();
  String _userError = '';
  String _passwordError = '';
  String _repasswordError = '';
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;
  Future<void> checkChangepass() async {
    try {
      final response = await http.post(
        Uri.parse('${Host.host}/resetpassword.php'),
        body: {'password': _passwordcontroller.text, 'email': widget.email},
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  //hàm kiểm tra password có trùng với password trước hay không
  void validateRepassword() {
    setState(() {
      final repassword = _repasswordcontroller.text.trim();
      if (repassword.isEmpty) {
        _repasswordError = 'Mật khẩu không được bỏ trống';
      } else if (repassword != _passwordcontroller.text.trim()) {
        _repasswordError = 'Mật khẩu không khớp';
      } else {
        _repasswordError = '';
      }
    });
  }

  //hàm kiểm tra password
void validatePassword() {
  setState(() {
    final accountPassword = _passwordcontroller.text.trim();
    if (accountPassword.isEmpty) {
      _passwordError = 'Mật khẩu không được bỏ trống';
    } else if (accountPassword.length < 8 || accountPassword.length > 32) {
      _passwordError = 'Mật khẩu phải có độ dài từ 8 đến 32 ký tự';
    } else if (!accountPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordError = 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt';
    } else {
      _passwordError = '';
    }
  });
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
                          builder: (context) => Loginscreen(),
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
                      child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Text('Thay đổi mật khẩu mới',style: TextStyle(
            fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold
          ),),
               SizedBox(height: 40),
              TextFormField(
                controller: _passwordcontroller,
                onChanged: (_) => validatePassword(),
                obscureText: !_isPasswordVisible1,
                decoration: InputDecoration(
                    hintText: "Password",
                           hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
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
                    errorText:
                        _passwordError.isNotEmpty ? _passwordError : null,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible1 = !_isPasswordVisible1;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,color: Colors.white
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _repasswordcontroller,
                onChanged: (_) => validateRepassword(),
                obscureText: !_isPasswordVisible2,
                decoration: InputDecoration(
                    hintText: "RePassword",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
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
                    errorText:
                        _repasswordError.isNotEmpty ? _repasswordError : null,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,color: Colors.white,
                      ),
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  validatePassword();
                  validateRepassword();
                  if (_userError.isEmpty &&
                      _passwordError.isEmpty &&
                      _repasswordError.isEmpty) {
                    checkChangepass();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Cập nhật mật khẩu thành công'),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                // Thực hiện hành động gửi lại email xác minh
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Index(selectedIndex: 2,))); // Đóng hộp thoại
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    print("Cập nhật mật khẩu thất bại");
                  }
                },
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
                child: const Text(
                  'Cập nhật mật khẩu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
