import 'package:bookstore/Views/ForgotPassword.dart';
import 'package:bookstore/Views/HomeScreen.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Profile.dart';
import 'package:bookstore/Views/VerificationScreen.dart';
import 'package:bookstore/WelcomeScreen.dart';
import 'package:bookstore/auth_config.dart';
import 'package:bookstore/Views/index.dart';

import 'package:bookstore/firebase_options.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

@override
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Home());
  }
}
