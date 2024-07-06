import 'dart:convert';

import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/OrderDetail.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OderManager extends StatefulWidget {
  const OderManager({super.key});

  @override
  State<OderManager> createState() => _OderManagerState();
}

class _OderManagerState extends State<OderManager> {
  Future loadOder() async {
    var result =
        await http.get(Uri.parse('http://192.168.1.10/getdataOder.php'));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Admin()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: loadOder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List oders = snapshot.data;
            return ListView.builder(
              itemCount: oders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text('Ma don hang ${oders[index]['order_id']}'),
                    Text('Nguoi mua hang ${oders[index]['email']}'),
                    Text('Tong tien ${oders[index]['total_price']}'),
                    Text('Trang thai ${oders[index]['order_status']}'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetail(
                                        order: oders[index],
                                      )));
                        },
                        child: const Text('Xem thông tin')),
                    TextButton(onPressed: () {}, child: const Text('Hủy đơn')),
                  ],
                );
              },
            );
          }
          return const Text('Chưa có đơn hàng');
        },
      ),
    );
  }
}
