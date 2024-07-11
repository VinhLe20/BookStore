import 'dart:convert';

import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/Admin.dart';
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
                    context, MaterialPageRoute(builder: (context) => Admin()));
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

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: 120,
                              height: 170,
                              child: Image.network(
                                "http://192.168.1.12/uploads/${products[index]['image']}",
                                fit: BoxFit.cover,https://github.com/VinhLe20/BookStore/pull/12/conflict?name=lib%252FViews%252FProductManagerScreen.dart&ancestor_oid=8766f7f33de94f2190839aaf3a2771a23d1f7dd3&base_oid=f1b2fd063334a7191cc256ddbe75e497c7f1c383&head_oid=18d99bb03d9ced5b40b05e664eb8ac4e9d0d577e
                              ),

                            ),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              height: 170,
                              child: SingleChildScrollView(
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
                                      width: MediaQuery.of(context).size.width -
                                          130,
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    pro.DeleteProduct(
                                                        products[index]['id']);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
