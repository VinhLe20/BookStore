import 'dart:convert';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/index.dart';
import 'package:bookstore/Views/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  List<String> selectedProducts = [];

  Future<List<dynamic>> loadCart() async {
    final uri = Uri.parse('${Host.host}/getCartDetail.php');

    var response = await http.get(uri);
    var data = json.decode(response.body);
    List filteredData =
        data.where((item) => item['user_id'] == User.id).toList();
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

    await http.post(uri,
        body: {'id': User.id, 'product_id': productId, 'quantity': quantity});

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
        .post(uri, body: {'product_id': productId, 'user_id': User.id});

    if (response.statusCode == 200) {
      print('sách đã được xóa thành công');
      loadCart();
    } else {
      print('Xóa sách không thành công');
    }
  }

  Future deleteALLProduct() async {
    final uri = Uri.parse('${Host.host}/deleteAllproducts.php');

    final response = await http.post(uri, body: {'user_id': User.id});

    if (response.statusCode == 200) {
      print('sách đã được xóa all thành công');
      loadCart();
    } else {
      print('Xóa sách all không thành công');
    }
  }

  Future deleteSelectedProducts() async {
    for (String productId in selectedProducts) {
      await deleteProduct(productId);
    }
    selectedProducts.clear();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    void confirmdelete(var xacnhan) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Bạn có muốn xóa sách này?',
        confirmBtnText: 'Có',
        cancelBtnText: 'Không',
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        onConfirmBtnTap: () async {
          await deleteProduct(xacnhan);
          setState(() {});
          Navigator.pop(context);
        },
      );
    }

    void confirmdeleteall() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Bạn có muốn xóa tất cả sách này?',
        confirmBtnText: 'Có',
        cancelBtnText: 'Không',
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        onConfirmBtnTap: () async {
          await deleteALLProduct();
          setState(() {});
          Navigator.pop(context);
        },
      );
    }

    void confirmdeleteSelected() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Bạn có muốn xóa các sách đã chọn?',
        confirmBtnText: 'Có',
        cancelBtnText: 'Không',
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        onConfirmBtnTap: () async {
          await deleteSelectedProducts();
          setState(() {});
          Navigator.pop(context);
        },
      );
    }

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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      confirmdeleteSelected();
                    },
                    child: Text(
                      "Xóa đã chọn",
                      style: TextStyle(color: Colors.red, fontSize: 17),
                    )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      confirmdeleteall();
                    },
                    child: Text(
                      "Xóa tất cả",
                      style: TextStyle(color: Colors.red, fontSize: 17),
                    )),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
                          Checkbox(
                            value: selectedProducts
                                .contains(products[index]['product_id']),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedProducts
                                      .add(products[index]['product_id']);
                                } else {
                                  selectedProducts
                                      .remove(products[index]['product_id']);
                                }
                              });
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            width: 120,
                            height: 190,
                            child: Image.network(
                              "${Host.host}/uploads/${products[index]['image']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              height: 190,
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
                                          confirmdelete(
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
                                                  products[index]
                                                      ["cart_quantity"]);
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
                                                  products[index]
                                                      ["cart_quantity"]);
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
                        ],
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (total != 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Payment(
                            quantity: '',
                            products: cart,
                            total: total.toString(),
                          )));
            }
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
                'Đặt hàng',
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
