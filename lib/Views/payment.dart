import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Payment extends StatefulWidget {
  Payment({super.key, required this.products});
  var products;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Tổng quan đơn hàng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
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
                  'Đường Lê Văn Thuộc,khu phố hòa thuận 1, thị trấn Cần Giuộc, huyện Cần Giuộc, tỉnh Long An',
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              const Text('Thông tin đơn hàng'),
              SizedBox(
                  height: 100, // Adjust the height as needed
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.black,
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
                                    Text('Đơn giá ${widget.products['price']}'),
                                    Text('- 1 +'),
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
              const Text('Chọn phương thức vận chuyển'),
              const Divider(),
              const Text('Tóm tắt đơn hàng'),
              Column(
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Tổng sản phẩm'), Text('222222đ')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Vận chuyển'), Text('222đ')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Tổng đơn hàng'), Text('222222đ')],
                  ),
                ],
              ),
              const Divider(),
              const Text('Phương thức thanh toán'),
              Column(
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Thanh toan khi nhan hang'),
                      Icon(Icons.radio_button_unchecked)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vi dien tu momo'),
                      Icon(Icons.radio_button_unchecked)
                    ],
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
              children: const [
                Text('Tổng'),
                Text('23627878đ'),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add your payment logic here
                },
                child: const Text("Thanh toán"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
