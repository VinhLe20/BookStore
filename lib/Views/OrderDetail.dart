import 'dart:convert';

import 'package:bookstore/Views/OderManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetail extends StatefulWidget {
  OrderDetail({super.key, this.order});
  var order;
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Future loadOrder() async {
    final uri = Uri.parse('http://192.168.1.10/getdataOrderDetail.php');
    var response = await http.get(uri);
    var data = json.decode(response.body).toList();
    var filteredData = data
        .where((item) => item['order_id'] == widget.order['order_id'])
        .toList();
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const OderManager()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: loadOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List order = snapshot.data;
            return ListView.builder(
                itemCount: order.length,
                itemBuilder: (context, index) {
                  return Column(
                      children: [Text(order[index]['order_quantity'])]);
                });
          }
          return const Text('');
        },
      ),
    );
  }
}
