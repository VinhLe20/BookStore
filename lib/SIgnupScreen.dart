import 'package:bookstore/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usercontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _repasswordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userError = '';
  String _passwordError = '';
  String _repasswordError = '';
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;

//hàm đăng kí tạo tài khoản
  void signup() async {
    try {
      final UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _usercontroller.text.trim(),
        password: _passwordcontroller.text.trim(),
      )
          .then((value) {
        FirebaseAuth.instance.currentUser
            ?.updateDisplayName(_usercontroller.text);
      }).onError((error, stackTrace) {
        print("Error ${error.toString()}");
      });
    } catch (e) {
      // Xử lý lỗi
      print(e.toString());
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
      } else if (accountPassword.length < 8 ||
          !accountPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        _passwordError = 'Mật khẩu tối đa 8 kí tự và chứa kí tự đặc biệt';
      } else {
        _passwordError = '';
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.jpeg",
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordcontroller,
                    onChanged: (_) => validatePassword(),
                    obscureText: !_isPasswordVisible1,
                    decoration: InputDecoration(
                        hintText: "Password",
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
                                : Icons.visibility_off,
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
                        errorText: _repasswordError.isNotEmpty
                            ? _repasswordError
                            : null,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible2 = !_isPasswordVisible2;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      validateEmail();
                      validatePassword();
                      validateRepassword();
                      if (_userError.isEmpty &&
                          _passwordError.isEmpty &&
                          _repasswordError.isEmpty) {
                        signup();
                        print("đăng ký thành công với email là :" +
                            _usercontroller.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginscreen()));
                      } else {
                        print("Đăng ký thất bại");
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
                          return Colors.red
                              .shade500; // Sử dụng màu nền mặc định (red.500)
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return null; // Màu chữ button khi được nhấn
                          }
                          return Colors
                              .white; // Sử dụng màu chữ mặc định (white)
                        },
                      ),
                    ),
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "Log in here",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginscreen()));
                        },
                      )
                    ],
                  ) // Khoảng cách giữa ảnh và chữ
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
