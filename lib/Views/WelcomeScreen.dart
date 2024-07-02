import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Profile.dart';
import 'package:bookstore/Views/SignupScreen.dart';

import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red.shade500,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
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
                const SizedBox(height: 16), // Khoảng cách giữa ảnh và chữ
                const Text(
                  'Welcome,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Center(
                  child: Text(
                    '“Our lives change in two ways :Through the people we meet and the books we read”',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen(
                                  email: '',
                                  password: '',
                                )));
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
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Loginscreen()));
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
                    'Login As Guest',
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
    );
  }
}
