import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/stripe_service.dart'; // Make sure to import your stripe_service.dart
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/TransactionHistory.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Payment extends StatefulWidget {
  final dynamic products;
  final String total;
  final String quantity;

  Payment(
      {Key? key,
      required this.products,
      required this.total,
      required this.quantity})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  Map<String, dynamic>? paymentIntent;
  String selectedShippingMethod = 'Bình thường';
  int shippingCost = 0;
  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';
  String order = '';
  final List<Map<String, dynamic>> shippingMethods = [
    {'method': 'Bình thường', 'cost': 0},
    {'method': 'Nhanh', 'cost': 20000},
  ];

  @override
  Widget build(BuildContext context) {
    int totalProductCost = int.parse(widget.total);
    int totalCost = totalProductCost + shippingCost;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: const Text(
          'Tổng quan đơn hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              const Text('Thông tin giao hàng'),
              // Add your shipping address UI here
              const Divider(),
              const SizedBox(height: 10.0),
              const Text('Thông tin đơn hàng'),
              widget.products is List
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200, // Adjust height as needed
                        child: ListView.builder(
                          itemCount: widget.products.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(
                                      '${Host.host}/uploads/${widget.products[index]['image']}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${widget.products[index]['name']}"),
                                      SizedBox(
                                        width: 200, // Adjust width as needed
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(formatCurrency.format(
                                                double.parse(
                                                    widget.products[index]
                                                        ['price']))),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("Số lượng: "),
                                          Text(
                                              "${widget.products[index]['cart_quantity']}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 100, // Adjust the height as needed
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                                "${Host.host}/uploads/${widget.products['image']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${widget.products['name']}"),
                                SizedBox(
                                  width: 200, // Adjust width as needed
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatCurrency.format(double.parse(
                                          widget.products['price']))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 10.0),

              Row(
                children: [
                  const Text('Chọn phương thức vận chuyển'),
                  SizedBox(
                    width: 30,
                  ),
                  DropdownButton<String>(
                    value: selectedShippingMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedShippingMethod = newValue!;
                        shippingCost = shippingMethods.firstWhere((method) =>
                            method['method'] == selectedShippingMethod)['cost'];
                      });
                    },
                    items:
                        shippingMethods.map<DropdownMenuItem<String>>((method) {
                      return DropdownMenuItem<String>(
                        value: method['method'],
                        child: Text(
                            '${method['method']} - ${formatCurrency.format(method['cost'])}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Text('Tóm tắt đơn hàng'),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng sách'),
                      Text(formatCurrency.format(totalProductCost)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vận chuyển'),
                      Text(formatCurrency.format(shippingCost)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng đơn hàng'),
                      Text(formatCurrency.format(totalCost)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10.0),
              const Text('Phương thức thanh toán'),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Thanh toán khi nhận hàng'),
                    value: 'Thanh toán khi nhận hàng',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  // RadioListTile<String>(
                  //   title: const Text('Ví điện tử Momo'),
                  //   value: 'Ví điện tử Momo',
                  //   groupValue: selectedPaymentMethod,
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       selectedPaymentMethod = value!;
                  //     });
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text('${formatCurrency.format(totalCost)} ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedPaymentMethod == 'Ví điện tử Momo') {
                    // Handle Momo payment
                    var items = [
                      {
                        'productPrice': 4,
                        'productName': "Apple",
                        'quantity': 5
                      },
                      {
                        'productPrice': 5,
                        'productName': "APpple",
                        'quantity': 5
                      }
                    ];
                    await StripeService.stripePaymentCheckout(
                      items,
                      500,
                      context,
                      mounted,
                      onSuccess: () {
                        print('Payment success');
                      },
                      onCancel: () {
                        print('Payment canceled');
                      },
                      onError: (e) {
                        print('Payment error: $e');
                      },
                    );
                  } else {
                    // Handle COD or other payment methods
                    await addOrder(totalCost.toString());
                    showLoadingDialog();
                    if (widget.products is List) {
                      for (var product in widget.products) {
                        addOrderDetail(
                          product['product_id'],
                          order,
                          product['cart_quantity'],
                        );
                        deleteProduct(product['product_id']);
                      }
                    } else {
                      addOrderDetail(
                        widget.products['id'],
                        order,
                        widget.quantity,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Colors.black, width: 1)),
                        minimumSize: Size(double.infinity, 70))
                    .copyWith(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white; // Màu nền button khi được nhấn
                      }
                      return Colors
                          .red.shade500; // Sử dụng màu nền mặc định (red.500)
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return null; // Màu chữ button khi được nhấn
                      }
                      return Colors.white; // Sử dụng màu chữ mặc định (white)
                    },
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addOrder(String total) async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    print(id);
    order = id;
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    print(User.id);
    print(total);

    var response = await http.post(
      Uri.parse('${Host.host}/addOrder.php'),
      body: {
        'id': id,
        'total': total,
        'user_id': User.id,
        'create': formattedDate,
      },
    );

    if (response.statusCode == 200) {
      print('Order added successfully');
    } else {
      print('Failed to add order');
    }
  }

  Future<void> addOrderDetail(
      String productId, String orderId, String quantity) async {
    var response = await http.post(
      Uri.parse('${Host.host}/addOrderDetail.php'),
      body: {
        'product_id': productId,
        'order_id': orderId,
        'quantity': quantity,
      },
    );

    if (response.statusCode == 200) {
      print('Order detail added successfully');
    } else {
      print('Failed to add order detail');
    }
  }

  Future<void> deleteProduct(String productId) async {
    var response = await http.post(
      Uri.parse('${Host.host}/deleteproducts.php'),
      body: {
        'product_id': productId,
        'cart_id': User.order_id,
      },
    );

    if (response.statusCode == 200) {
      print('Product deleted successfully');
    } else {
      print('Failed to delete product');
    }
  }

  void showLoadingDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading...',
      text: 'Please wait',
      autoCloseDuration: Duration(seconds: 2),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Transactionhistory()),
      );
    });
  }
}
