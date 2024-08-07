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

  final _formKey = GlobalKey<FormState>();

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
    if (!_formKey.currentState!.validate()) {
      showFailedDialog();
      return;
    }

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
          return Form(
            key: _formKey,
            child: ListView(
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
                buildTextFormField(
                    "Full Name", nameController, "Tên không được bỏ trống"),
                buildTextFormField("Email", emailController,
                    "Email không được bỏ trống", validateEmail),
                buildTextFormField("Phone", phoneController,
                    "Số điện thoại không được bỏ trống", validatePhone),
                buildTextFormField("Location", addressController,
                    "Địa chỉ không được bỏ trống"),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.info
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Index(selectedIndex: 2)),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(
                                    fontSize: 14, letterSpacing: 2.2),
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
                        if (_formKey.currentState!.validate())
                          updateUser(User.id);
                        else {
                          showFailedDialog();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
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
            ),
          );
        },
      ),
    );
  }

  Widget buildTextFormField(
    String labelText,
    TextEditingController controller,
    String emptyErrorText, [
    Function(String)? additionalValidator,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return emptyErrorText;
          } else if (additionalValidator != null) {
            return additionalValidator(value);
          }
          return null;
        },
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            setState(() {});
          }
        },
      ),
    );
  }

  void showSuccessDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Cập nhật thông tin thành công!',
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Index(selectedIndex: 2)),
          (Route<dynamic> route) => false,
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

  String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Email không được bỏ trống';
    } else if (!_isValidEmail(email)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  String? validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return 'Số điện thoại không được bỏ trống';
    } else if (!isValidVietnamesePhoneNumber(phone)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }
}
