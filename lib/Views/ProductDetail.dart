import 'dart:convert';

import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/index.dart';
import 'package:bookstore/Views/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  var product;

  ProductDetail({required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List comment = [];
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    loadDataComment().then((value) {
      setState(() {
        comment = value;
      });
    });
  }

  Future<List> loadDataComment() async {
    final uri = Uri.parse('http://192.168.1.10/getdataComment.php');
    var response = await http.get(uri);
    var data = json.decode(response.body).toList();
    var filteredData = data
        .where((item) => item['product_id'] == widget.product['id'])
        .toList();
    return filteredData;
  }

  String loaddanhgia() {
    double tong = 0.0;
    int count = 0;
    for (var value in comment) {
      tong += double.parse(value['rate'].toString());
      count++;
    }
    if (count > 0) {
      return (tong / count).toStringAsFixed(1);
    } else {
      return "0";
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future addCart(String oder_id, String product_id, String quantity) async {
    final uri = Uri.parse('http://192.168.1.10/addCart.php');

    http.post(uri, body: {
      'cart_id': oder_id,
      'product_id': product_id,
      'quantity': quantity,
    });
    print('thêm');
  }

  Future addCartDetail(
      String oder_id, String product_id, String quantity) async {
    final uri = Uri.parse('http://192.168.1.10/addCartDetail.php');
    http.post(uri, body: {
      'cart_id': oder_id,
      'product_id': product_id,
      'quantity': quantity,
    });
    print('them ');
  }

  Future<bool> loadCart(String product_id) async {
    final uri = Uri.parse('http://192.168.1.10/getCartDetail.php');
    var response = await http.get(uri);
    var data = json.decode(response.body);
    var cart = data.where((item) => item['cart_id'] == User.order_id).toList();
    var product =
        cart.where((item) => item['product_id'] == product_id).toList();
    return product.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        backgroundColor: Colors.teal,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Index()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'http://192.168.1.10/uploads/${widget.product['image']}',
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.product['price']} đ',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product["name"],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tác giả: ${widget.product["author"]}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Thể loại: ${widget.product["category_name"]}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        "${loaddanhgia().toString()} ",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20.0,
                      ),
                      Text(
                        "| Đã bán ${widget.product['sold']} ",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        "Số lượng",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _decrementQuantity,
                              icon: const Icon(
                                Icons.remove,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: _incrementQuantity,
                              icon: const Icon(
                                Icons.add,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Giới thiệu về sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Đánh giá của khách hàng',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: comment.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comment.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        comment[index]['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              comment[index]['rate'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    comment[index]['comment'],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 4),
                                ],
                              );
                            },
                          )
                        : const Row(
                            children: [
                              Text("Chưa có đánh giá nhận xét"),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (await loadCart(widget.product['id'])) {
                    print("da co san pham");
                  } else {
                    addCart('${User.order_id}', widget.product['id'], '1');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Thêm vào giỏ hàng',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  int total = int.parse(widget.product['price']) * _quantity;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Payment(
                                quantity: _quantity.toString(),
                                products: widget.product,
                                total: total.toString(),
                              )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Mua ngay',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
