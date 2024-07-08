import 'dart:convert';
import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OderManager extends StatefulWidget {
  const OderManager({super.key});

  @override
  State<OderManager> createState() => _OderManagerState();
}

class _OderManagerState extends State<OderManager>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<List> loadOder() async {
    var result =
        await http.get(Uri.parse('http://192.168.1.6:8012/getdataOder.php'));
    return json.decode(result.body);
  }

  Future cancelorder(String id) async {
    final uri = Uri.parse('http://192.168.1.6:8012/cancelOrder.php');
    await http.post(uri, body: {'id': id});
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
                Text('Người mua hàng: ${filteredOrders[index]['email']}'),
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
                              setState(() {
                                loadOder();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Hủy đơn'),
                          )
                        : Text(''),
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
                context, MaterialPageRoute(builder: (context) => Admin()));
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
