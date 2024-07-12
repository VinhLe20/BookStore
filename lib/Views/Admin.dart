import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/Views/CategoryManager.dart';
import 'package:bookstore/Views/OderManager.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:bookstore/Views/RateManager.dart';
import 'package:bookstore/Views/statistical.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text(
          'Quản lý cửa hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildListItem(
            context,
            'Quản lý sách',
            Icons.shopping_bag,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductManager(),
                ),
              );
            },
          ),
          _buildListItem(
            context,
            'Quản lý đơn hàng',
            Icons.shopping_cart,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OderManager(),
                ),
              );
            },
          ),
          _buildListItem(
            context,
            'Quản lý đánh giá nhận xét',
            Icons.star,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RateManager(),
                ),
              );
            },
          ),
          _buildListItem(
            context,
            'Quản lý tài khoản',
            Icons.person,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserManager(),
                ),
              );
            },
          ),
          _buildListItem(
            context,
            'Thống kê báo cáo',
            Icons.analytics,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Statistical(),
                ),
              );
            },
          ),
          _buildListItem(
            context,
            'Đăng xuất',
            Icons.logout,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Loginscreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward),
    );
  }
}
