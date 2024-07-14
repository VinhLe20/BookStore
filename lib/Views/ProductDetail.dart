import 'dart:convert';

import 'package:bookstore/Model/cardProduct.dart';

import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/LoginScreen.dart';
import 'package:bookstore/Views/index.dart';
import 'package:bookstore/Views/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProductDetail extends StatefulWidget {
  var product;

  ProductDetail({required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  List data = [];

  List comment = [];
  List categori = [];
  int _quantity = 1;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadProduct();
    _loadcategori();
    _quantityController = TextEditingController(text: '$_quantity');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _loadData() {
    loadDataComment().then((value) {
      setState(() {
        comment = value;
      });
    });
  }


  void _loadProduct() {
    loadAuthor(widget.product['author']).then(
      (value) {
        setState(() {
          data = value;
        });
      },
    );
  }

  void _loadcategori() {
    loadcategory(widget.product['category_name']).then(
      (value) {
        setState(() {
          categori = value;
        });
      },
    );
  }

  Future<List> loadDataComment() async {
    final uri = Uri.parse('${Host.host}/getdataComment.php');

    var response = await http.get(uri);
    var data = json.decode(response.body).toList();
    var filteredData = data
        .where((item) => item['product_id'] == widget.product['id'])
        .toList();
    return filteredData;
  }

  Future<List> loadAuthor(String author) async {
    final uri =
        Uri.parse('${Host.host}/getdataauthorProduct.php?author=$author');

    var response = await http.get(uri);
    print(response.body);
    return json.decode(response.body);
  }

  Future<List> loadcategory(String categori) async {
    final uri = Uri.parse(
        '${Host.host}/getdatacategoriProduct.php?category_name=$categori');

    var response = await http.get(uri);
    print(response.body);
    return json.decode(response.body);
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
    if (_quantity < int.parse(widget.product['quantity'])) {
      setState(() {
        _quantity++;
        _quantityController.text = '$_quantity';
      });
    } else {
      _showExceedStockDialog();
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = '$_quantity';
      });
    }
  }


  void _updateQuantity(String value) {
    int newQuantity = int.tryParse(value) ?? 1;
    if (newQuantity <= int.parse(widget.product['quantity'])) {
      setState(() {
        _quantity = newQuantity;
      });
    } else {
      _quantityController.text = widget.product['quantity'];
      _showExceedStockDialog();
    }
  }

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

  void _showExceedStockDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Lỗi',
      widget: const Center(
        child: Center(
          child: Text(
            'Số lượng vượt quá số lượng sản phẩm trong kho!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List filteredData =
        data.where((item) => item['id'] != widget.product['id']).toList();
    if (data.length < 10) {
      data.addAll(categori);
    }

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


    void showFailedDialog() {

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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết sách',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Index()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              '${Host.host}/uploads/${widget.product['image']}',
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
                    formatCurrency
                        .format(double.parse(widget.product['price'])),
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
                      IconButton(
                        onPressed: _decrementQuantity,
                        icon: const Icon(
                          Icons.remove,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 80,
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: _updateQuantity,
                        ),
                      ),
                      IconButton(
                        onPressed: _incrementQuantity,
                        icon: const Icon(
                          Icons.add,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Giới thiệu về sách',
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
                  SizedBox(height: 10),
                  const Text(
                    'Sách liên quan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CardProduct(product: filteredData[index]),
                          );
                        },
                      ))
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

                  if (!User.guest) {
                    if (await loadCart(widget.product['id'])) {
                      print("da co san pham");
                      showFailedDialog();
                    } else {
                      addCart('${User.id}', widget.product['id'], '$_quantity');
                      showSuccessDialog();
                    }
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Loginscreen()));

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
                  if (!User.guest) {
                    int total = int.parse(widget.product['price']) * _quantity;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Payment(
                                  quantity: _quantity.toString(),
                                  products: widget.product,
                                  total: total.toString(),
                                )));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Loginscreen()));
                  }
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
