import 'dart:io';

import 'package:bookstore/Model/imagePicker.dart';
import 'package:bookstore/Model/product.dart';
import 'package:flutter/material.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  Product newproduct =
      Product(id: "", name: "", quantity: "", image: "", price: "", mota: "");
  imagePicker image = imagePicker();
  var tensp = TextEditingController();
  var soluongsp = TextEditingController();
  var dongiasp = TextEditingController();
  var motasp = TextEditingController();
  String imagenetwork = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm mới'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  await image.pickImage();
                  setState(() {});
                },
                child: Text('tai anh')),
            Container(
              width: 100,
              height: 100,
              child: imagePicker.path.isEmpty
                  ? null
                  : Image.file(File(imagePicker.path), fit: BoxFit.cover),
            ),
            Text('ten san pham'),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: tensp,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
            ),
            Text('so luong san pham'),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: soluongsp,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
            ),
            Text('don gia san pham'),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: dongiasp,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
            ),
            Text('mo ta san pham'),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: motasp,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
            ),
            TextButton(
                onPressed: () async {
                  String imageNetwork = await image.uploadImageToFirebase();
                  newproduct.ProductAdd(tensp.text, soluongsp.text,
                      dongiasp.text, motasp.text, imageNetwork);
                },
                child: Text('Them moi'))
          ],
        ),
      ),
    );
  }
}
