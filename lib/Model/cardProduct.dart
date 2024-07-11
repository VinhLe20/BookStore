import 'dart:convert';

import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/ProductDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CardProduct extends StatelessWidget {
  CardProduct({super.key, required this.product});
  var product;
  Future addCart(String oder_id, String product_id, String quantity) async {

    final uri = Uri.parse('http://192.168.1.12/addCartDetail.php');


    http.post(uri, body: {
      'cart_id': oder_id,
      'product_id': product_id,
      'quantity': quantity,
    });

    print('them ');
  }

  Future<bool> loadCart(String product_id) async {

    final uri = Uri.parse('http://192.168.1.12/getCartDetail.php');

    var response = await http.get(uri);
    var data = json.decode(response.body);
    var cart = data.where((item) => item['cart_id'] == User.order_id).toList();
    var product =
        cart.where((item) => item['product_id'] == product_id).toList();
    return product.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
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

                'http://192.168.1.12/uploads/${product['image']}',

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
                  '${product['price']} đ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Đã bán ${product['sold']}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                if (await loadCart(product['id'])) {
                  print("da co san pham");
                } else {
                  addCart('${User.order_id}', product['id'], '1');
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
