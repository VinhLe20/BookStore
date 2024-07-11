import 'dart:convert';

import 'package:bookstore/Model/cardProduct.dart';
import 'package:bookstore/Views/Category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Productcategory extends StatefulWidget {
  Productcategory({super.key, required this.category});
  var category;
  @override
  State<Productcategory> createState() => _ProductcategoryState();
}

class _ProductcategoryState extends State<Productcategory> {
  Future loadProductbyCategory(String categoryID) async {
    final uri = Uri.parse(
        'http://192.168.1.13:8012/getProductCategory.php?categoryID=$categoryID');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Thể loại ${widget.category['name']}'),
          backgroundColor: Colors.blue,
          leading: IconButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Category()
          ));
          }, icon: Icon(Icons.arrow_back))),
      body: FutureBuilder(
        future: loadProductbyCategory(widget.category['id'].toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var products = snapshot.data;
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return CardProduct(product: products[index]);
                });
          } else {
            return Center(child: Text("Không có sách"));
          }
        },
      ),
    );
  }
}
