import 'dart:convert';

import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/ProductAddScreen.dart';
import 'package:bookstore/Views/ProductEdit.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductManager extends StatefulWidget {
  const ProductManager({Key? key}) : super(key: key);

  @override
  State<ProductManager> createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  Product pro = Product(
      id: "",
      name: "",
      quantity: "",
      image: "",
      price: "",
      mota: '',
      category: "",
      author: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý sản phẩm'),
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Index()));
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProductAdd()));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: FutureBuilder(
          future: pro.loadProduct(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List products = snapshot.data;
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            width: 100,
                            height: 170,
                            child: Image.network(
                              "http://192.168.1.9:8012/flutter/uploads/${products[index]['image']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            height: 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tên sản phẩm: ${products[index]['name']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tác giả: ${products[index]['author']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Thể loại: ${products[index]['category_name']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Đơn giá: ${products[index]["price"]} đ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Số lượng: ${products[index]["quantity"]}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Đã bán ${products[index]['sold']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Container(
                                          child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductEdit(
                                                                pro: products[
                                                                    index])));
                                              },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                var result;
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Xác nhận xóa'),
                                                      content:
                                                          const SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                                'Bạn có chắc chắn muốn xóa sản phẩm này không?'),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('Hủy'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child:
                                                              const Text('Xóa'),
                                                          onPressed: () {
                                                            pro.DeleteProduct(
                                                                products[
                                                                    index]);
                                                            result = true;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (result) {
                                                  setState(() {});
                                                }
                                              },
                                              icon: const Icon(Icons.delete)),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : const CircularProgressIndicator();
          },
        ));
  }
}
