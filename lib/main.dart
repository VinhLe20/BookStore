import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/index.dart';
import 'package:bookstore/WelcomeScreen.dart';
import 'package:bookstore/app/app_sp.dart';
import 'package:bookstore/app/app_sp_key.dart';
import 'package:bookstore/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: FutureBuilder<Widget>(
        future: checkLogin(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }

  Future<Widget> checkLogin() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('login')) {
        return Welcomescreen();
      }

      final bool? login = prefs.getBool('login');
      final String? userId = prefs.getString('user_id');

      if (login == null || userId == null) {
        return Welcomescreen();
      }

      User.id = userId;

      return login != true ? Welcomescreen() : Index();
    } catch (e) {
      print("Có lỗi xảy ra: $e");
      return Welcomescreen();
    }
  }
}
