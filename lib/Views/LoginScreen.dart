import 'package:bookstore/Views/SIgnupScreen.dart';
import 'package:bookstore/Views/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  String _userError = '';
  String _passwordError = '';
  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "không tồn tại") {
        print("Không tìm thấy user");
      }
    }
    return user;
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

//hàm kiểm tra mật khẩu
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

  final _usercontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.jpeg",
                    width: 250,
                    height: 250,
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
                    obscureText: !_isPasswordVisible,
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
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      validateEmail();
                      validatePassword();
                      var user = await loginUsingEmailPassword(
                          email: _usercontroller.text,
                          password: _passwordcontroller.text,
                          context: context);
                      print(user);

                      if (user != null) {
                        print("Email là : " + _usercontroller.text);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Welcomescreen()));
                        //Gọi hàm đăng nhập thành công
                      } else {
                        print("User or Password is not Correct !!");
                        //Gọi hàm đăng nhập thất bại
                      }
                      ;
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
                      'Login As Guest',
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
                          "Don't have an account yet? ",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "Sign up here",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
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
