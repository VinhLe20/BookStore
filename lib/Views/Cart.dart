import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/index.dart';
import 'package:bookstore/Views/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  List cart = [];
  int total = 0;

  Future<List<dynamic>> loadCart() async {
    final uri = Uri.parse('${Host.host}/getCartDetail.php');

    var response = await http.get(uri);
    var data = json.decode(response.body);
    List filteredData =
        data.where((item) => item['cart_id'] == User.order_id).toList();
    calculateTotal(filteredData);
    return filteredData;
  }

  void calculateTotal(List products) {
    int newTotal = 0;
    for (var product in products) {
      newTotal +=
          int.parse(product['cart_quantity']) * int.parse(product['price']);
    }
    setState(() {
      total = newTotal;
    });
  }

  Future updateQuantity(String productId, String quantity) async {
    final uri = Uri.parse('${Host.host}/updatequantity.php');

    await http.post(uri, body: {
      'id': User.order_id,
      'product_id': productId,
      'quantity': quantity
    });
    loadCart();
  }

  void increaseQuantity(String productId, String quantity) {
    String newQuantity = (int.parse(quantity) + 1).toString();
    updateQuantity(productId, newQuantity);
  }

  void decreaseQuantity(String productId, String quantity) {
    int currentQuantity = int.parse(quantity);
    if (currentQuantity > 1) {
      String newQuantity = (currentQuantity - 1).toString();
      updateQuantity(productId, newQuantity);
    }
  }

  Future deleteProduct(String productId) async {
    final uri = Uri.parse('${Host.host}/deleteproducts.php');

    final response = await http
        .post(uri, body: {'product_id': productId, 'cart_id': User.order_id});

    if (response.statusCode == 200) {
      print('sách đã được xóa thành công');
      loadCart();
    } else {
      print('Xóa sách không thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Index()));
          },
        ),
      ),
      body: FutureBuilder(
        future: loadCart(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List? products = snapshot.data;
            cart = products!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: 120,
                      height: 170,
                      child: Image.network(
                        "${Host.host}/uploads/${products[index]['image']}",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        height: 170,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${products[index]['name']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tác giả: ${products[index]['author']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      formatCurrency.format(double.parse(
                                          products[index]["price"])),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteProduct(
                                          products[index]['product_id']);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Số lượng: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          decreaseQuantity(
                                              products[index]['product_id'],
                                              products[index]["cart_quantity"]);
                                        },
                                      ),
                                      Text(
                                        products[index]["cart_quantity"]
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          increaseQuantity(
                                              products[index]['product_id'],
                                              products[index]["cart_quantity"]);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Payment(
                          quantity: '',
                          products: cart,
                          total: total.toString(), // Ensure total is a string
                        )));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 144, 84, 80),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
            minimumSize: Size(double.infinity, 70),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white; // Màu nền button khi được nhấn
                }
                return Colors
                    .red.shade500; // Sử dụng màu nền mặc định (red.500)
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return null; // Màu chữ button khi được nhấn
                }
                return Colors.white; // Sử dụng màu chữ mặc định (white)
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Buy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tổng tiền: ${formatCurrency.format(total)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
