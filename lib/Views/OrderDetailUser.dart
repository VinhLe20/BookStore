import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/OderManager.dart';
import 'package:bookstore/Views/TransactionHistory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OrderDetailUser extends StatefulWidget {
  const OrderDetailUser({Key? key, required this.order}) : super(key: key);
  final Map<String, dynamic> order;

  @override
  State<OrderDetailUser> createState() => _OrderDetailUserState();
}

class _OrderDetailUserState extends State<OrderDetailUser> {
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  List order = [];

  Future<List> loadOrder() async {
    final uri = Uri.parse('${Host.host}/getdataOrderDetail.php');

    var response = await http.get(uri);
    var data = json.decode(response.body) as List;
    var filteredData = data
        .where((item) => item['order_id'] == widget.order['order_id'])
        .toList();
    return filteredData;
  }

  Future<void> approveOrder(String id) async {
    final uri = Uri.parse('${Host.host}/approveorder.php');
    await http.post(uri, body: {'id': id});
  }

  Future<void> updateQuantity(String id, String quantity) async {
    final uri = Uri.parse('${Host.host}/updatequantityproduct.php');
    await http.post(uri, body: {'id': id, 'quantity': quantity});
  }

  Future<void> cancelOrder(String id) async {
    final uri = Uri.parse('${Host.host}/cancelOrder.php');
    await http.post(uri, body: {'id': id});
  }

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
        await cancelOrder(xacnhan);
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Transactionhistory()));
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: loadOrder(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            order = snapshot.data!;
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
                              "${Host.host}/uploads/${order[index]['image']}"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tên sách: ${order[index]['product_name']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text("Tác giả: ${order[index]['author']}"),
                              const SizedBox(height: 5),
                              Text(
                                  "Thể loại: ${order[index]['category_name']}"),
                              const SizedBox(height: 5),
                              Text(
                                  "Đơn giá: ${formatCurrency.format(double.parse(order[index]['price']))}"),
                              const SizedBox(height: 5),
                              Text("Số lượng: ${order[index]['quantity']}"),
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
        child: widget.order["order_status"] == "Đang chờ"
            ? Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        confirmdelete(widget.order['order_id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                      ),
                      child: const Text(
                        'Hủy đơn',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Text(''),
      ),
    );
  }
}
