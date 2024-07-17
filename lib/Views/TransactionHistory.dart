import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/OrderDetailUser.dart';
import 'package:bookstore/Views/ProfileScreen.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/OrderDetail.dart';
import 'package:bookstore/Views/ReviewScreen.dart'; // Import ReviewScreen

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Transactionhistory extends StatefulWidget {
  const Transactionhistory({super.key});

  @override
  State<Transactionhistory> createState() => _TransactionhistoryState();
}

class _TransactionhistoryState extends State<Transactionhistory>
    with SingleTickerProviderStateMixin {
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<List> loadOder() async {
    var result = await http.get(Uri.parse('${Host.host}/getdataOder.php'));

    var orders = json.decode(result.body);
    return orders.where((order) => order['user_id'] == User.id).toList();
  }

  Future cancelorder(String id) async {
    final uri = Uri.parse('${Host.host}/cancelOrder.php');
    await http.post(uri, body: {'id': id});
  }

  Future received(String id) async {
    final uri = Uri.parse('${Host.host}/received.php');
    await http.post(uri, body: {'id': id});
  }

  Future<void> reviewOrder(var order) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewScreen(order: order)),
    );
  }

  Widget buildOrderList(List orders, String status) {
    void confirmdelete(var xacnhan) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Bạn có muốn hủy đơn này?',
        confirmBtnText: 'Có',
        cancelBtnText: 'Không',
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        onConfirmBtnTap: () async {
          await cancelorder(xacnhan);
          setState(() {});
          Navigator.pop(context);
        },
      );
    }

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
                Text(
                  'Tổng tiền: ${formatCurrency.format(double.parse(filteredOrders[index]['total_price']))}',
                ),
                SizedBox(height: 5),
                Text('Trạng thái thanh toán: ${filteredOrders[index]['pay']}'),
                SizedBox(height: 10),
                Text(
                    'Trạng thái đơn hàng: ${filteredOrders[index]['order_status']}'),
                SizedBox(height: 10),
                Text('Ngày đặt hàng: ${filteredOrders[index]['create']}'),
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
                                OrderDetailUser(order: filteredOrders[index]),
                          ),
                        );
                      },
                      child: const Text('Xem thông tin'),
                    ),
                    filteredOrders[index]['order_status'] == 'Đang chờ'
                        ? ElevatedButton(
                            onPressed: () {
                              confirmdelete(filteredOrders[index]['order_id']);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade500),
                            child: const Text(
                              'Hủy đơn',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : filteredOrders[index]['order_status'] ==
                                'Đang chờ giao hàng'
                            ? ElevatedButton(
                                onPressed: () async {
                                  await received(
                                      filteredOrders[index]['order_id']);
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade500),
                                child: const Text(
                                  'Đã nhận hàng',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
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
                                            backgroundColor:
                                                Colors.green.shade500),
                                        child: const Text(
                                          'Nhận xét đánh giá',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
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
                                        backgroundColor: Colors.green.shade500),
                                    child: const Text(
                                      'Hủy đơn',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
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
        backgroundColor: Colors.green.shade500,
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Index(selectedIndex: 2)));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text(
                  'Đang chờ',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  overflow: TextOverflow.visible,
                ),
              ),
              Tab(
                child: Text(
                  'Đang chờ giao hàng',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  overflow: TextOverflow.visible,
                ),
              ),
              Tab(
                child: Text(
                  'Đã giao hàng',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  overflow: TextOverflow.visible,
                ),
              ),
              Tab(
                child: Text(
                  'Đã hủy',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
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
                buildOrderList(orders, 'Đã hủy'),
              ],
            );
          }
          return const Center(child: Text('Chưa có đơn hàng'));
        },
      ),
    );
  }
}
