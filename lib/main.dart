import 'package:bookstore/Views/index.dart';
import 'package:bookstore/WelcomeScreen.dart';
import 'package:bookstore/app/app_sp.dart';
import 'package:bookstore/app/app_sp_key.dart';
import 'package:bookstore/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      "pk_test_51PbE052Kp0Ros8xQ2BSShPPjbDMn79CR39LqhHD0QdmlDrgd9UcxZOpNLNBJqlonRHjXRPYZoUIIzu4zMsstRCcq00bSTrJCCX";
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
        home: Welcomescreen());
  }
}
