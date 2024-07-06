import 'package:bookstore/Views/CategoryManager.dart';
import 'package:bookstore/Views/OderManager.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:bookstore/Views/RateManager.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OderManager(),
                  ));
            },
            child: Text('Quản lý đơn hàng'))
      ],
    );
  }
}
