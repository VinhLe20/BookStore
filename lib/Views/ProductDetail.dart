import 'dart:convert';

import 'package:bookstore/Views/index.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      loadDataComment().then((value) {
        setState(() {
          comment = value;
        });
      });
    });
  }

  Future<List> loadDataComment() async {
    final uri = Uri.parse('http://192.168.1.7:8012/flutter/getdataComment.php');
    var response = await http.get(uri);
    var data = json.decode(response.body).toList();
    var filteredData =
        data.where((item) => item['sanpham'] == widget.product['id']).toList();
    return filteredData;
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
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'http://192.168.1.7:8012/flutter/uploads/${widget.product['hinhanh']}',
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product["ten"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product['dongia']}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product['mota'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Nhận xét',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comment.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment[index]['hoten'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        comment[index]['danhgia'],
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 30.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment[index]['nhanxet'],
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        );
                      },
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
                onPressed: () {},
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
                onPressed: () {},
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
