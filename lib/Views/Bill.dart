import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookstore/Views/TransactionHistory.dart';

class Bill extends StatelessWidget {
  var products;
  String total;
  String selectedPaymentMethod;
  String selectedShippingMethod;
  String shippingCost;
  String quantity;

  Bill({
    required this.products,
    required this.total,
    required this.selectedPaymentMethod,
    required this.selectedShippingMethod,
    required this.shippingCost,
    required this.quantity,
  });

  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  Widget build(BuildContext context) {
    List<dynamic> productList = (products is List) ? products : [products];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hóa đơn',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade500,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chi tiết đơn hàng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Tên sản phẩm',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Số lượng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Đơn giá',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Thành tiền',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...productList
                      .map((product) => buildProductRow(product))
                      .toList(),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Phương thức vận chuyển: ${selectedShippingMethod} ${formatCurrency.format(double.parse(shippingCost))}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Hình thức thanh toán: ${selectedPaymentMethod}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng tiền: ${formatCurrency.format(double.parse(total))}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Transactionhistory(),
                  ),
                );
              },
              child: Text(
                'Lịch sử giao dịch',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildProductRow(dynamic product) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product['name'] ?? ''),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product['cart_quantity'] != null
                ? product['cart_quantity'].toString()
                : quantity),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                formatCurrency.format(double.parse(product['price'] ?? '0'))),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(formatCurrency.format(
                double.parse(product['price'] ?? '0') *
                    (product['cart_quantity'] != null
                        ? double.parse(product['cart_quantity'].toString())
                        : double.parse(quantity)))),
          ),
        ),
      ],
    );
  }
}
