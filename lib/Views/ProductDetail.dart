import 'dart:collection';
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
  final Map<String, dynamic> product;

  ProductDetail({required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  late TextEditingController _quantityController;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '$_quantity');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final comment = await loadDataComment();
    final data = await loadAuthor(widget.product['author']);
    final category = await loadCategory(widget.product['category_name']);
    return {
      'comment': comment,
      'data': data,
      'category': category,
    };
  }

  Future<List> loadDataComment() async {
    final uri = Uri.parse('${Host.host}/getdataComment.php');
    var response = await http.get(uri);
    var data = json.decode(response.body).toList();
    return data
        .where((item) => item['product_id'] == widget.product['id'])
        .toList();
  }

  Future<List> loadAuthor(String author) async {
    final uri =
        Uri.parse('${Host.host}/getdataauthorProduct.php?author=$author');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future<List> loadCategory(String category) async {
    final uri = Uri.parse(
        '${Host.host}/getdatacategoriProduct.php?category_name=$category');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  String loadRating(List comment) {
    if (comment.isEmpty) return "0";
    double total =
        comment.fold(0.0, (sum, item) => sum + double.parse(item['rate']));
    return (total / comment.length).toStringAsFixed(1);
  }

  void _incrementQuantity() {
    if (_quantity < int.parse(widget.product['quantity'])) {
      setState(() => _quantity++);
      _quantityController.text = '$_quantity';
    } else {
      _showExceedStockDialog();
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
      _quantityController.text = '$_quantity';
    }
  }

  void _updateQuantity(String value) {
    int newQuantity = int.tryParse(value) ?? 1;
    if (newQuantity <= int.parse(widget.product['quantity'])) {
      setState(() => _quantity = newQuantity);
    } else {
      _quantityController.text = widget.product['quantity'];
      _showExceedStockDialog();
    }
  }

  Future<void> addCart(String product_id, String quantity) async {
    final uri = Uri.parse('${Host.host}/addCart.php');
    await http.post(uri, body: {
      'user_id': User.id,
      'product_id': product_id,
      'quantity': quantity,
    });
  }

  Future<bool> isProductInCart(String product_id) async {
    final uri = Uri.parse('${Host.host}/getCartDetail.php');
    var response = await http.get(uri);
    var data = json.decode(response.body);
    return data.any((item) =>
        item['user_id'] == User.id && item['product_id'] == product_id);
  }

  void _showExceedStockDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Lỗi',
      widget: const Center(
        child: Text('Số lượng vượt quá số lượng sản phẩm trong kho!',
            style: TextStyle(fontSize: 20)),
      ),
    );
  }

  void _showSuccessDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      widget: const Center(
        child: Text('Thêm vào giỏ hàng thành công!',
            style: TextStyle(fontSize: 20)),
      ),
    );
  }

  void _showFailedDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Warning!',
      widget: const Center(
        child: Text('Đã có trong giỏ hàng', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Chi tiết sách', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Index())),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final data = snapshot.data!;
            final comment = data['comment'] as List;
            final relatedData = data['data'] as List;
            final categoryData = data['category'] as List;
            List filteredData = relatedData
                .where((item) => item['id'] != widget.product['id'])
                .toList();

            if (relatedData.length < 10) {
              filteredData.addAll(categoryData);
            }

            return SingleChildScrollView(
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
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.product["name"],
                          maxLines: 5,
                          style: const TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text('Tác giả: ${widget.product["author"]}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Thể loại: ${widget.product["category_name"]}',
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text("${loadRating(comment)} ",
                                style: const TextStyle(fontSize: 16)),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20.0),
                            Text("| Đã bán ${widget.product['sold']} ",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text("Số lượng",
                                style: TextStyle(fontSize: 16)),
                            IconButton(
                              onPressed: _decrementQuantity,
                              icon: const Icon(Icons.remove, size: 14),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                onChanged: _updateQuantity,
                              ),
                            ),
                            IconButton(
                              onPressed: _incrementQuantity,
                              icon: const Icon(Icons.add, size: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Giới thiệu về sách',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(widget.product['description'],
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Text('Đánh giá của khách hàng',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0)),
                          child: comment.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comment.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              comment[index]['user_name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19),
                                            ),
                                            Row(
                                              children: [
                                                Text(comment[index]['rate'],
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                                const Icon(Icons.star,
                                                    color: Colors.amber,
                                                    size: 20.0),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(comment[index]['comment'],
                                            style:
                                                const TextStyle(fontSize: 15)),
                                        const Divider(),
                                        const SizedBox(height: 4),
                                      ],
                                    );
                                  },
                                )
                              : const Row(children: [
                                  Text("Chưa có đánh giá nhận xét")
                                ]),
                        ),
                        const SizedBox(height: 10),
                        const Text('Sách liên quan',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child:
                                    CardProduct(product: filteredData[index]),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (!User.guest) {
                    if (await isProductInCart(widget.product['id'])) {
                      _showFailedDialog();
                    } else {
                      await addCart(widget.product['id'], '$_quantity');
                      _showSuccessDialog();
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
                onPressed: () {
                  if (!User.guest) {
                    int total = int.parse(widget.product['price']) * _quantity;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment(
                          quantity: _quantity.toString(),
                          products: widget.product,
                          total: total.toString(),
                        ),
                      ),
                    );
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
