import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/Admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  State<UserManager> createState() => _UserManagerState();
}

Future<List<dynamic>> Getuser() async {
  Uri uri = Uri.parse('${Host.host}/getuser.php');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load users');
  }
}

Future<void> lockUserAccount(String userId) async {
  Uri uri = Uri.parse('${Host.host}/BlockUser.php');
  final response = await http.post(uri, body: {'id': userId});
  print(userId);
  if (response.statusCode != 200) {
    throw Exception('Failed to lock user account');
  }
}

class _UserManagerState extends State<UserManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          backgroundColor: Colors.green.shade500,
          title: const Text(
            "Quản lý tài khoản",
            style: TextStyle(color: Colors.white),
          ),

          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Admin()));
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ))),
      body: FutureBuilder<List<dynamic>>(
        future: Getuser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var user = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${user['name']}"),
                          const SizedBox(height: 5),
                          Text("Email: ${user['email']}"),
                          const SizedBox(height: 5),
                          Text("Password: ${user['password']}"),
                          const SizedBox(height: 5),
                          Text("Phone: ${user['phone']}"),
                          const SizedBox(height: 5),
                          Text("Address: ${user['address']}"),
                          const SizedBox(height: 10),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.lock),
                        onPressed: () async {
                          try {
                            await lockUserAccount("${user['id']}");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User account locked')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to lock account')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
