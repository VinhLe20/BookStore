import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  Future<List> loadOrder() async {
    var result = await http.get(Uri.parse('${Host.host}/getdataOder.php'));
    return json.decode(result.body);
  }

  Future<void> cancelOrder(String id) async {
    final uri = Uri.parse('${Host.host}/cancelOrder.php');
    await http.post(uri, body: {'id': id});
    setState(() {}); // Update the UI after canceling the order
  }

  void confirmdelete(var xacnhan) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Bạn có muốn hủy đơn này?',
      confirmBtnText: 'Có',
      cancelBtnText: 'Không',
      confirmBtnColor: Colors.green,
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      onConfirmBtnTap: () async {
        await cancelOrder(xacnhan);
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  Widget buildOrderList(List orders, String status) {
    NumberFormat formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    List filteredOrders =
        orders.where((order) => order['order_status'] == status).toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng'));
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text('Người mua hàng: ${filteredOrders[index]['email']}'),
                const SizedBox(height: 5),
                Text(
                    'Tổng tiền: ${formatCurrency.format(double.parse(filteredOrders[index]['total_price']))}'),
                const SizedBox(height: 5),
                Text('Trạng thái thanh toán: ${filteredOrders[index]['pay']}'),
                const SizedBox(height: 10),
                Text(
                    'Trạng thái đơn hàng: ${filteredOrders[index]['order_status']}'),
                const SizedBox(height: 10),
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
                    if (filteredOrders[index]['order_status'] == 'Đang chờ')
                      ElevatedButton(
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
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Admin()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  'Đang chờ',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size if needed
                  overflow: TextOverflow.visible,
                ),
              ),
              Tab(
                child: Text(
                  'Đang chờ giao hàng',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size if needed
                  overflow: TextOverflow.visible,
                ),
              ),
              Tab(
                child: Text(
                  'Đã giao thành công',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size if needed
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: loadOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List orders = snapshot.data as List;
            return TabBarView(
              controller: _tabController,
              children: [
                buildOrderList(orders, 'Đang chờ'),
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
