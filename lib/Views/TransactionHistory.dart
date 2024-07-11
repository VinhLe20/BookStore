import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/ProfileScreen.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/OrderDetail.dart';
import 'package:bookstore/Views/ReviewScreen.dart'; // Import ReviewScreen

import 'package:http/http.dart' as http;

class Transactionhistory extends StatefulWidget {
  const Transactionhistory({super.key});

  @override
  State<Transactionhistory> createState() => _TransactionhistoryState();
}

class _TransactionhistoryState extends State<Transactionhistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<List> loadOder() async {
    var result =
        await http.get(Uri.parse('http://192.168.1.12/getdataOder.php'));

    var orders = json.decode(result.body);
    return orders.where((order) => order['user_id'] == User.id).toList();
  }

  Future cancelorder(String id) async {
    final uri = Uri.parse('http://192.168.1.12/cancelOrder.php');
    await http.post(uri, body: {'id': id});
  }

  Future received(String id) async {
    final uri = Uri.parse('http://192.168.1.12/received.php');
    await http.post(uri, body: {'id': id});
  }

  Future<void> reviewOrder(var order) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewScreen(order: order)),
    );
  }

  Widget buildOrderList(List orders, String status) {
    List filteredOrders =
        orders.where((order) => order['order_status'] == status).toList();

    if (filteredOrders.isEmpty) {
      return Center(child: Text('Không có đơn hàng'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã đơn hàng: ${filteredOrders[index]['order_id']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 5),
                User.role == 'user'
                    ? Text('')
                    : Text('Người mua hàng: ${filteredOrders[index]['email']}'),
                SizedBox(height: 5),
                Text('Tổng tiền: ${filteredOrders[index]['total_price']}đ'),
                SizedBox(height: 5),
                Text('Trạng thái thanh toán: ${filteredOrders[index]['pay']}'),
                SizedBox(height: 10),
                Text(
                    'Trạng thái đơn hàng: ${filteredOrders[index]['order_status']}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetail(order: filteredOrders[index]),
                          ),
                        );
                      },
                      child: const Text('Xem thông tin'),
                    ),
                    filteredOrders[index]['order_status'] == 'Đang chờ'
                        ? ElevatedButton(
                            onPressed: () {
                              cancelorder(filteredOrders[index]['order_id']);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Hủy đơn'),
                          )
                        : filteredOrders[index]['order_status'] ==
                                'Đang chờ giao hàng'
                            ? ElevatedButton(
                                onPressed: () {
                                  received(filteredOrders[index]['order_id']);
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text('Đã nhận hàng'),
                              )
                            : filteredOrders[index]['order_status'] ==
                                    'Đã giao thành công'
                                ? Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          print(filteredOrders[index]);
                                          reviewOrder(filteredOrders[index]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue),
                                        child: const Text('Nhận xét đánh giá'),
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      cancelorder(
                                          filteredOrders[index]['order_id']);
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text('Hủy đơn'),
                                  ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                context,
                MaterialPageRoute(
                    builder: (context) => Index(selectedIndex: 2)));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đang chờ'),
            Tab(text: 'Đang chờ giao hàng'),
            Tab(text: 'Đã giao thành công'),
          ],
        ),
      ),
      body: FutureBuilder(
        future: loadOder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List? orders = snapshot.data;
            return TabBarView(
              controller: _tabController,
              children: [
                buildOrderList(orders!, 'Đang chờ'),
                buildOrderList(orders, 'Đang chờ giao hàng'),
                buildOrderList(orders, 'Đã giao thành công'),
              ],
            );
          }
          return const Center(child: Text('Chưa có đơn hàng'));
        },
      ),
    );
  }
}
