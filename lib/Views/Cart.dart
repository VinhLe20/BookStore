import 'dart:convert';

import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  const Cart({Key? key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Future<List<dynamic>> loadCart() async {
    final uri = Uri.parse('http://192.168.1.10/getCartDetail.php');
    var response = await http.get(uri);
    var data = json.decode(response.body);
    return data.where((item) => item['order_id'] == User.order_id).toList();
  }

  Future updatequantity(String productId, String quantity) async {
    final uri = Uri.parse('http://192.168.1.10/updatequantity.php');
    var response = await http.post(uri, body: {
      'id': User.order_id,
      'product_id': productId,
      'quantity': quantity
    });
  }

  void increaseQuantity(String productId, String quantity) {
    quantity = (int.parse(quantity) + 1).toString();
    updatequantity(productId, quantity);

    setState(() {
      loadCart();
    });
  }

  void decreaseQuantity(String productId, String quantity) {
    int currentQuantity = int.parse(quantity);
    if (currentQuantity > 1) {
      String newQuantity = (currentQuantity - 1).toString();
      updatequantity(productId, newQuantity);

      setState(() {
        loadCart();
      });
    }
  }

  Future deleteproduct(String productid) async {
    final uri = Uri.parse('http://192.168.1.10/deleteproducts.php');
    final response = await http
        .post(uri, body: {'product_id': productid, 'order_id': User.order_id});

    if (response.statusCode == 200) {
      // Xóa thành công
      print('Sản phẩm đã được xóa thành công');
      setState(() {
        loadCart();
      });
    } else {
      // Xóa thất bại
      print('Xóa sản phẩm không thành công');
    }
  }

  void handlePayment() {
    // Xử lý khi người dùng nhấn nút thanh toán
    print("Thanh toán");
  }
  //tổng tiền

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Index()));
          },
        ),
      ),
      body: FutureBuilder(
        future: loadCart(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    List? products = snapshot.data;
                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          width: 120,
                          height: 170,
                          child: Image.network(
                            "http://192.168.1.10/uploads/${products?[index]['image']}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          height: 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Tên sản phẩm: ${products?[index]['name']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tác giả: ${products?[index]['author']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Đơn giá: ${products?[index]["price"]} đ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteproduct(
                                          products?[index]['product_id']);
                                      print(products?[index]['product_id']);
                                      print(User.order_id);
                                      print("Delete button pressed");
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
                                              products?[index]['product_id'],
                                              products?[index]
                                                  ["cart_quantity"]);
                                        },
                                      ),
                                      Text(
                                        products![index]["cart_quantity"]
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
                                                products[index]
                                                    ["cart_quantity"]);
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
              : CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: handlePayment,
          style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.black, width: 1)),
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Buy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tổng tiền: đ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
