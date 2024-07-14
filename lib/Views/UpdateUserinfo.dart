import 'dart:convert';

import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Updateuserinfo extends StatefulWidget {
  const Updateuserinfo({super.key});

  @override
  State<Updateuserinfo> createState() => _UpdateuserinfoState();
}

class _UpdateuserinfoState extends State<Updateuserinfo> {
  late Future<List<Map<String, dynamic>>> futureUser;

  // TextEditingController for each field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String nameError = '';
  String phoneError = '';
  String addressError = '';

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
        phoneController.text = user[0]['phone'];
        addressController.text = user[0]['address'];
      }
      return user.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUser(String id) async {
    final uri = Uri.parse('${Host.host}/UpdateUserInfo.php');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': User.id,
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {

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
                  "Cập nhật trang cá nhân",
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
              buildTextField("Họ tên", nameController, nameError, validateName),
              buildTextField(
                  "Số điện thoại", phoneController, phoneError, validatePhone,
                  keyboardType: TextInputType.number),
              buildTextField(
                  "Địa chỉ", addressController, addressError, validateAddress),
              const SizedBox(height: 35),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    validateName();
                    validatePhone();
                    validateAddress();
                    if (nameError.isEmpty &&
                        phoneError.isEmpty &&
                        addressError.isEmpty) {
                      updateUser(User.id);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Loginscreen()));
                    } else {
                      showFailedDialog();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
    String errorText,
    Function validateFunction, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        onChanged: (_) => validateFunction(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          errorText: errorText.isNotEmpty ? errorText : null,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        keyboardType: keyboardType,
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

  void showFailedDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Lỗi!',
      text: 'Cập nhật thông tin thất bại',
    );
  }

  void validateName() {
    setState(() {
      final name = nameController.text.trim();
      if (name.isEmpty) {
        nameError = 'Họ tên không được bỏ trống';
      } else if (name.length > 32) {
        nameError = 'Họ tên không được vượt quá 32 kí tự';
      } else {
        nameError = '';
      }
    });
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

  void validateAddress() {
    setState(() {
      final address = addressController.text.trim();
      if (address.isEmpty) {
        addressError = 'Địa chỉ không được bỏ trống';
      } else {
        addressError = '';
      }
    });
  }
}
