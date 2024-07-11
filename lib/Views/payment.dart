import 'dart:convert';

import 'package:bookstore/Model/stripe_service.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/TransactionHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Payment extends StatefulWidget {
  Payment(
      {super.key,
      required this.products,
      required this.total,
      required this.quantity});
  final dynamic products;
  String total;
  String quantity;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? paymentIntent;
  String selectedShippingMethod = 'Bình thường';
  int shippingCost = 0;
  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';
  String order = '';
  final List<Map<String, dynamic>> shippingMethods = [
    {'method': 'Bình thường', 'cost': 0},
    {'method': 'Nhanh', 'cost': 20000},
  ];
  Future addOrder(String total) async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    print(id);
    order = id;
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    print(User.id);
    print(total);

    http.post(Uri.parse('http://192.168.1.12/addOrder.php'), body: {

      'id': id,
      'total': total,
      'user_id': User.id,
      'create': formattedDate
    });
  }

  Future addOrderDetail(
      String productId, String orderId, String quantity) async {

    http.post(Uri.parse('http://192.168.1.12/addOrderDetail.php'), body: {

      'product_id': productId,
      'order_id': orderId,
      'quantity': quantity
    });
  }

  Future deleteProduct(String productId) async {

    final uri = Uri.parse('http://192.168.1.12/deleteproducts.php');

    final response = await http
        .post(uri, body: {'product_id': productId, 'cart_id': User.order_id});

    if (response.statusCode == 200) {
      print('Sản phẩm đã được xóa thành công');
    } else {
      print('Xóa sản phẩm không thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalProductCost = int.parse(widget.total);
    int totalCost = totalProductCost + shippingCost;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Tổng quan đơn hàng'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 5),
                  Text(
                    'Lechivinh 0937569365',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 22.0, top: 5.0),
                child: Text(
                  'Đường Lê Văn Thuộc, khu phố hòa thuận 1, thị trấn Cần Giuộc, huyện Cần Giuộc, tỉnh Long An',
                ),
              ),
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

                                      'http://192.168.1.12/uploads/${widget.products[index]['image']}'),

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
                                            Text(
                                                'Đơn giá ${widget.products[index]['price']} đ'),
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
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                  "http://192.168.1.12/uploads/${widget.products['image']}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${widget.products['name']}"),
                                  SizedBox(
                                    width: 200, // Adjust width as needed
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Đơn giá ${widget.products['price']} đ'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
              const Divider(),
              Row(
                children: [
                  const Text('Chọn phương thức vận chuyển'),
                  SizedBox(
                    width: 20,
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
                        child:
                            Text('${method['method']} - ${method['cost']} đ'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const Divider(),
              const Text('Tóm tắt đơn hàng'),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng sản phẩm'),
                      Text("$totalProductCost đ")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Vận chuyển'), Text('$shippingCost đ')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Tổng đơn hàng'), Text('$totalCost đ')],
                  ),
                ],
              ),
              const Divider(),
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
                    title: const Text('Ví điện tử Momo'),
                    value: 'Ví điện tử Momo',
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng'),
                Text('$totalCost đ'),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // await makePayment();
                  print('Selected Payment Method: $selectedPaymentMethod');
                  if (selectedPaymentMethod == 'Ví điện tử Momo') {
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
                        items, 500, context, mounted, onSuccess: () {
                      print('1');
                    }, onCancel: () {
                      print('2');
                    }, onError: (e) {
                      print('3');
                    });
                    // payonline();
                  } else {
                    addOrder(totalCost.toString());
                    showLoadingDialog();
                    if (widget.products is List) {
                      for (var product in widget.products) {
                        print("order id: $order");
                        print("Product id :  ${product['product_id']}");
                        print("quantity :  ${product['cart_quantity']}");
                        addOrderDetail(product['product_id'], order,
                            product['cart_quantity']);
                        deleteProduct(product['product_id']);
                      }
                    } else {
                      addOrderDetail(
                          widget.products['id'], order, widget.quantity);
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

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10000', 'USD');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);
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
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('Thất bại');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://buy.stripe.com/test_5kAcOMg9Y6J0a2c289'),
        headers: {
          'Authorization':
              'sk_test_51PbE052Kp0Ros8xQ8sywuANHEYQDBCLcWWYRlYXXTIYRen2Gelw2xBaIWqgwEy1eFBYS9xKMJOSXmzjKY8runCnt00seF6162q',
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
