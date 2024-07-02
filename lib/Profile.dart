import 'package:bookstore/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  String email = '';
  User1 _user = User1(email: '', password: '');
  String pass = '';
  @override
  void initState() {
    super.initState();
    print("emailllllllllllllllllll${user?.email}");
    loadUser();
  }

  void loadUser() {
    _user.load(user?.email).then((value) {
      setState(() {
        email = _user.email;
        pass = _user.password;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Container(
                  child: const Center(
                    child: Text(
                      "Account",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/avt.jpeg",
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Text("email    $email"),
          Text(pass)
          // Expanded(
          //   child: FirebaseAnimatedList(
          //     query: databaseReference.orderByChild('BookStore').limitToLast(1),
          //     itemBuilder: (context, snapshot, index, animation) {
          //       String email = snapshot.child('email').value.toString();
          //       String password = snapshot.child('password').value.toString();
          //       return Column(
          //         children: [
          //           ConstrainedBox(
          //             constraints: const BoxConstraints(
          //               minHeight: 60,
          //             ),
          //             child: Container(
          //               padding: EdgeInsets.all(16.0),
          //               decoration: BoxDecoration(
          //                 color: Colors.grey.shade300,
          //                 borderRadius: BorderRadius.circular(8.0),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey.withOpacity(0.5),
          //                     spreadRadius: 2,
          //                     blurRadius: 5,
          //                     offset: Offset(0, 3),
          //                   ),
          //                 ],
          //               ),
          //               child: Text(
          //                 "Email: $email",
          //                 style: TextStyle(fontSize: 25),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 20),
          //           ConstrainedBox(
          //             constraints: const BoxConstraints(
          //               minHeight: 60,
          //             ),
          //             child: Container(
          //               padding: EdgeInsets.all(16.0),
          //               decoration: BoxDecoration(
          //                 color: Colors.grey.shade300,
          //                 borderRadius: BorderRadius.circular(8.0),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey.withOpacity(0.5),
          //                     spreadRadius: 2,
          //                     blurRadius: 5,
          //                     offset: Offset(0, 3),
          //                   ),
          //                 ],
          //               ),
          //               child: TextField(
          //                 controller: TextEditingController(text: password),
          //                 obscureText: !_showPassword,
          //                 style: TextStyle(fontSize: 20),
          //                 readOnly: true,
          //                 decoration: InputDecoration(
          //                   labelText: "Password",
          //                   border: InputBorder.none,
          //                   suffixIcon: GestureDetector(
          //                     onTap: () {
          //                       setState(() {
          //                         _showPassword = !_showPassword;
          //                       });
          //                     },
          //                     child: Icon(
          //                       _showPassword
          //                           // ignore: dead_code
          //                           ? Icons.visibility
          //                           : Icons.visibility_off,
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 30,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               ElevatedButton(
          //                 onPressed: () {
          //                   // Add your 'Edit' functionality here
          //                 },
          //                 child: const Text('Edit'),
          //               ),
          //               ElevatedButton(
          //                 onPressed: () async {
          //                   try {
          //                     // Đăng xuất người dùng khỏi Firebase Authentication
          //                     await FirebaseAuth.instance.signOut();
          //                     print('Người dùng đã đăng xuất thành công');
          //                     Navigator.pushReplacement(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) => Welcomescreen()));
          //                   } catch (e) {
          //                     print('Lỗi khi đăng xuất: $e');
          //                   }
          //                 },
          //                 child: const Text('Log out'),
          //               ),
          //             ],
          //           ),
          //         ],
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
