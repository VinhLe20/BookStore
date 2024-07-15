import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/ProfileScreen.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.info});
  bool info;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<List<Map<String, dynamic>>> futureUser;
  bool showPassword = false;

  // TextEditingController for each field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String emailError = '';
  String phoneError = '';

  @override
  void initState() {
    super.initState();
    futureUser = loadUser(User.id); // Replace '1' with the actual user ID
  }

  Future<List<Map<String, dynamic>>> loadUser(String id) async {
    final uri = Uri.parse('${Host.host}/getuser.php');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var user = data.where((item) => item['id'] == id).toList();
      if (user.isNotEmpty) {
        // Initialize the controllers with user data
        nameController.text = user[0]['name'];
        emailController.text = user[0]['email'];
        phoneController.text = user[0]['phone'];
        addressController.text = user[0]['address'];
      }
      return user.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUser(String id) async {
    final uri = Uri.parse('${Host.host}/EditProfile.php');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': User.id,
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update user')),
      );
    }
  }

  bool isValidVietnamesePhoneNumber(String phoneNumber) {
    String pattern = r'^(09|08|03|07|05)+([0-9]{8})$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Map<String, dynamic>> user = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            children: [
              const Center(
                child: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Stack(
                  children: [
                    Container(width: 130, height: 130),
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              buildTextField("Full Name", nameController),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: emailController,
                  onChanged: (_) => validateEmail(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: 'Email',
                    errorText: emailError.isNotEmpty ? emailError : null,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: phoneController,
                  onChanged: (_) => validatePhone(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: 'Phone',
                    errorText: phoneError.isNotEmpty ? phoneError : null,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              buildTextField("Location", addressController),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.info
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Index(
                                          selectedIndex: 2,
                                        )));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 14, letterSpacing: 2.2),
                            ),
                          ),
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Text(''),
                  ElevatedButton(
                    onPressed: () {
                      if (emailError.isEmpty && phoneError.isEmpty)
                        updateUser(User.id);
                      else {
                        showFailedDIalog();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 14, letterSpacing: 2.2),
                      ),
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: controller.text,
        ),
      ),
    );
  }

  void showSuccessDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Cập nhật thông tin thành công!',
      onConfirmBtnTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Index(
                    selectedIndex: 2,
                  )),
        );
      },
    );
  }

  void showFailedDIalog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Lỗi!',
      text: 'Cập nhật thông tin thất bại',
    );
  }

  void validateEmail() {
    setState(() {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        emailError = 'Email không được bỏ trống';
      } else if (!_isValidEmail(email)) {
        emailError = 'Email không hợp lệ';
      } else {
        emailError = '';
      }
    });
  }

  bool _isValidEmail(String email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void validatePhone() {
    setState(() {
      final phone = phoneController.text.trim();
      if (phone.isEmpty) {
        phoneError = 'Số điện thoại không được bỏ trống';
      } else if (!isValidVietnamesePhoneNumber(phone)) {
        phoneError = 'Số điện thoại không hợp lệ';
      } else {
        phoneError = '';
      }
    });
  }
}
