import 'dart:convert';

import 'package:bookstore/Views/OderManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetail extends StatefulWidget {
  OrderDetail({super.key, this.order});
  final order;

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Future loadOrder() async {

    final uri = Uri.parse('http://192.168.1.8/getdataOrderDetail.php');

    var response = await http.get(uri);
    var data = json.decode(response.body).toList();
    var filteredData = data
        .where((item) => item['order_id'] == widget.order['order_id'])
        .toList();
    return filteredData;
  }

  Future approveorder(String id) async {
    final uri = Uri.parse('http://192.168.1.6:8012/approveorder.php');
    await http.post(uri, body: {'id': id});
  }

  Future cancelorder(String id) async {
    final uri = Uri.parse('http://192.168.1.6:8012/cancelOrder.php');
    await http.post(uri, body: {'id': id});
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
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                              "http://192.168.1.6:8012/uploads/${order[index]['image']}"),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tên sản phẩm: ${order[index]['name']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text("Tác giả: ${order[index]['author']}"),
                              SizedBox(height: 5),
                              Text(
                                  "Thể loại: ${order[index]['category_name']}"),
                              SizedBox(height: 5),
                              Text("Đơn giá: ${order[index]['price']}đ"),
                              SizedBox(height: 5),
                              Text(
                                  "Số lượng: ${order[index]['order_quantity']}"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('Đang tải...'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  approveorder(widget.order['order_id']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Duyệt đơn'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  cancelorder(widget.order['order_id']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Hủy đơn'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
