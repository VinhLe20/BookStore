import 'dart:convert';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/Bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:bookstore/Model/host.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Payment extends StatefulWidget {
  final dynamic products;
  final String total;
  final String quantity;

  Payment({
    Key? key,
    required this.products,
    required this.total,
    required this.quantity,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? paymentIntent;
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  String selectedShippingMethod = 'Bình thường';
  int shippingCost = 0;
  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';
  String order = '';
  var user;
  final List<Map<String, dynamic>> shippingMethods = [
    {'method': 'Bình thường', 'cost': 0},
    {'method': 'Nhanh', 'cost': 20000},
  ];

  @override
  void initState() {
    super.initState();
  }

  Future loadUser() async {
    final uri = Uri.parse('${Host.host}/getUserbyID.php?id=${User.id}');
    var response = await http.get(uri);
    return json.decode(response.body).toList();
  }

  void showSuccessDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        widget: Center(
            child: Text(
          'Thanh toán thành công!',
          style: TextStyle(fontSize: 20),
        )));
  }

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
      body: FutureBuilder(
        future: loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load user data'));
          } else if (snapshot.hasData) {
            user = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    const Text('Thông tin giao hàng'),
                    const SizedBox(height: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Text('${user[0]["name"]}',
                                style: TextStyle(fontSize: 17)),
                            SizedBox(width: 3),
                            Text('${user[0]["phone"]}',
                                style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Địa chỉ: ${user[0]["address"]}',
                              style: TextStyle(fontSize: 17)),
                        )
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10.0),
                    const Text('Thông tin đơn hàng'),
                    widget.products is List
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 200,
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
                                      Expanded(
                                        // Bọc Text widget trong Expanded để giới hạn không gian
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "${widget.products[index]['name']}"),
                                              SizedBox(
                                                width: 200,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(formatCurrency.format(
                                                        double.parse(widget
                                                                .products[index]
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
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 150, // Adjust the height as needed
                            child: Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 100,
                                  child: Image.network(
                                      "${Host.host}/uploads/${widget.products['image']}"),
                                ),
                                Expanded(
                                  // Bọc Text widget trong Expanded để giới hạn không gian
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Sách ${widget.products['name']}",
                                          maxLines: 2,
                                        ),
                                        Text(
                                            "Tác giả ${widget.products['author']}"),
                                        Text(
                                            "Thể loại ${widget.products['category_name']}"),
                                        SizedBox(
                                          width: 200, // Adjust width as needed
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Đơn giá ${formatCurrency.format(double.parse(widget.products['price']))}"),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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
                              shippingCost = shippingMethods.firstWhere(
                                  (method) =>
                                      method['method'] ==
                                      selectedShippingMethod)['cost'];
                            });
                          },
                          items: shippingMethods
                              .map<DropdownMenuItem<String>>((method) {
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
                        RadioListTile<String>(
                          title: const Text('Thanh toán trực tuyến'),
                          value: 'Thanh toán trực tuyến',
                          groupValue: selectedPaymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No user data found'));
          }
        },
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
                  if (selectedPaymentMethod == 'Thanh toán trực tuyến') {
                    await makePayment(totalCost);
                  } else {
                    await addOrder(totalCost.toString(), 'chưa thanh toán');
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Bill(
                              products: widget.products,
                              total: totalCost.toString(),
                              selectedPaymentMethod: selectedPaymentMethod,
                              selectedShippingMethod: selectedShippingMethod,
                              shippingCost: shippingCost.toString(),
                              quantity: widget.quantity.toString()),
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade500,
                  textStyle: TextStyle(fontSize: 18),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Thanh toán',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addOrder(String total, String pay) async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    order = id;
    var response = await http.post(
      Uri.parse('${Host.host}/addOrder.php'),
      body: {'id': id, 'total': total, 'user_id': User.id, 'pay': pay},
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
        'user_id': User.id,
      },
    );

    if (response.statusCode == 200) {
      print('Product deleted successfully');
    } else {
      print('Failed to delete product');
    }
  }

  Future<void> makePayment(int total) async {
    print(total);
    try {
      paymentIntent = await createPaymentIntent(total.toString(), 'VND');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "VN", currencyCode: "VND", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Abhi',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(total);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet(int total) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        addOrder(total.toString(), 'đã thanh toán');

        print("Payment Successfully");
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
        showSuccessDialog();
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Bill(
                      products: widget.products,
                      total: total.toString(),
                      selectedPaymentMethod: selectedPaymentMethod,
                      selectedShippingMethod: selectedShippingMethod,
                      shippingCost: shippingCost.toString(),
                      quantity: widget.quantity.toString()),
                ));
          });
        });
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51PbE052Kp0Ros8xQ8sywuANHEYQDBCLcWWYRlYXXTIYRen2Gelw2xBaIWqgwEy1eFBYS9xKMJOSXmzjKY8runCnt00seF6162q',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
