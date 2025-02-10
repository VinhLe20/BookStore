import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/Admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  State<UserManager> createState() => _UserManagerState();
}

Future<List<dynamic>> getUser() async {
  Uri uri = Uri.parse('${Host.host}/getusermanager.php');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load users');
  }
}

Future<void> toggleUserAccountStatus(String userId, bool isLocked) async {
  String endpoint = isLocked ? '/OpenBlockUser.php' : '/BlockUser.php';
  Uri uri = Uri.parse('${Host.host}$endpoint');
  final response = await http.post(uri, body: {'user_id': userId});
  if (response.statusCode != 200) {
    throw Exception('Failed to update user account status');
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
              context,
              MaterialPageRoute(builder: (context) => Admin()),
            );
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getUser(),
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
                bool isLocked = user['status'] == '0';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          Text("Họ tên: ${user['name']}"),
                          const SizedBox(height: 5),
                          Text("Email: ${user['email']}"),
                          const SizedBox(height: 5),
                          Text("Số điện thoại: ${user['phone']}"),
                          const SizedBox(height: 5),
                          Text("Địa chỉ: ${user['address']}"),
                          const SizedBox(height: 5),
                          Text(
                            "Trạng thái: ${isLocked ? 'Đã khóa' : 'Hoạt động'}",
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(isLocked ? Icons.lock : Icons.lock_open_outlined),
                        onPressed: () async {
                          try {
                            await toggleUserAccountStatus(user['id'], isLocked);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isLocked
                                      ? 'Tài khoản đã được mở khóa'
                                      : 'Tài khoản đã bị khóa',
                                ),
                              ),
                            );
                            setState(() {});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update account status'),
                              ),
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
