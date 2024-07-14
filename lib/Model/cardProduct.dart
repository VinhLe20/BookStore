import 'dart:convert';
import 'dart:ffi';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/ProductDetail.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CardProduct extends StatelessWidget {
  CardProduct({super.key, required this.product});
  var product;

  Future addCart(String oder_id, String product_id, String quantity) async {

    final uri = Uri.parse('${Host.host}/addCart.php');

    http.post(uri, body: {
      'user_id': User.id,
      'product_id': product_id,
      'quantity': quantity,
    });
    print('them ');
  }

  Future<bool> loadCart(String product_id) async {
    final uri = Uri.parse('${Host.host}/getCartDetail.php');
    var response = await http.get(uri);
    var data = json.decode(response.body);
    var cart = data.where((item) => item['user_id'] == User.id).toList();
    var product =
        cart.where((item) => item['product_id'] == product_id).toList();
    return product.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    void showSuccessDialog() {
      QuickAlert.show(

          context: context,
          type: QuickAlertType.success,
          widget: Center(
              child: Text(
            'Thêm vào giỏ hàng thành công!',
            style: TextStyle(fontSize: 20),
          )));

    }

    void showFailedDIalog() {
      QuickAlert.show(

          context: context,
          type: QuickAlertType.warning,
          title: 'Warning!',
          widget: Center(
              child: Text(
            'Đã có trong giỏ hàng',
            style: TextStyle(fontSize: 20),
          )));

    }

    // Định dạng tiền tệ cho Đồng Việt Nam
    NumberFormat formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      width: 170,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(product: product)));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Image.network(
                '${Host.host}/uploads/${product['image']}',
                fit: BoxFit.cover,
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 5),
            child: Text(
              product['name'],
              maxLines: 2,
              style: const TextStyle(
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatCurrency.format(double.parse(product['price'])),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Đã bán ${product['sold']}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () async {

                if (!User.guest) {
                  if (await loadCart(product['id'])) {
                    print("da co san pham");
                    showFailedDIalog();
                  } else {
                    addCart('${User.id}', product['id'], '1');
                    showSuccessDialog();
                  }
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Loginscreen()));

                }
              },
              child: const Text(
                'Thêm vào giỏ hàng',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
