import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/VerificationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final String email;
  final String password;
  const SignupScreen({super.key, required this.email, required this.password});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usercontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _repasswordcontroller = TextEditingController();
  String _userError = '';
  String _passwordError = '';
  String _repasswordError = '';
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;

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

  //gửi email từ firebase
  void registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usercontroller.text,
        password: _passwordcontroller.text,
      );

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
                              builder: (context) => VerificationScreen(
                                    email: _usercontroller.text,
                                    password: _passwordcontroller.text,
                                  )),
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

  bool _isValidEmail(String email) {
    // Biểu thức chính quy để kiểm tra định dạng email
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
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
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đăng ký tài khoản',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _usercontroller,
                    onChanged: (_) => validateEmail(),
                    style: TextStyle(color: Colors.white), // Màu chữ trắng
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle:
                          TextStyle(color: Colors.white), // Màu gợi ý trắng
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 30.0,
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
                      errorStyle:
                          TextStyle(color: Colors.white), // Màu lỗi trắng
                      suffixIcon: IconButton(
                        onPressed: () {
                          _usercontroller.clear();
                        },
                        icon: Icon(Icons.close_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordcontroller,
                    onChanged: (_) => validatePassword(),
                    obscureText: !_isPasswordVisible1,
                    style: TextStyle(color: Colors.white), // Màu chữ trắng
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle:
                          TextStyle(color: Colors.white), // Màu gợi ý trắng
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
                      errorStyle:
                          TextStyle(color: Colors.white), // Màu lỗi trắng
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
                          color: Colors.white, // Màu biểu tượng trắng
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _repasswordcontroller,
                    onChanged: (_) => validateRepassword(),
                    obscureText: !_isPasswordVisible2,
                    style: TextStyle(color: Colors.white), // Màu chữ trắng
                    decoration: InputDecoration(
                      hintText: "RePassword",
                      hintStyle:
                          TextStyle(color: Colors.white), // Màu gợi ý trắng
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
                      errorStyle:
                          TextStyle(color: Colors.white), // Màu lỗi trắng
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
                          color: Colors.white, // Màu biểu tượng trắng
                        ),
                      ),
                    ),
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
                        registerUser();
                        verifyEmailAndLogin(context);
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
                      'Đăng ký',
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
                          "Bạn đã có tài khoản? ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
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
        ],
      ),
    );
  }
}
