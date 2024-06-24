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
  Product pro =
      Product(id: "", name: "", quantity: "", image: "", price: "", mota: '');

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
              icon: Icon(Icons.arrow_back)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ProductAdd()));
          },
          child: Icon(Icons.add),
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
                            padding: EdgeInsets.all(5.0),
                            width: 100,
                            height: 150,
                            child: Image.network(
                              "http://192.168.1.9:8012/flutter/uploads/${products[index]['hinhanh']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  products[index]['ten'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Thể loại',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Price: \$${products[index]["dongia"]}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${products[index]["soluong"]}',
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
                                        'Da ban',
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
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                pro.DeleteProduct(
                                                    products[index]);
                                              },
                                              icon: Icon(Icons.delete)),
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
                : CircularProgressIndicator();
          },
        ));
  }
}
