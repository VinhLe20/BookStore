import 'dart:io';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  Product newproduct =
      Product(id: "", name: "", quantity: "", image: "", price: "", mota: "");
  var tensp = TextEditingController();
  var soluongsp = TextEditingController();
  var dongiasp = TextEditingController();
  var motasp = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> choiceImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm mới'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProductManager()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                await choiceImage();
              },
              child: Text('Tải ảnh'),
            ),
            Container(
              width: 100,
              height: 100,
              child: _image == null
                  ? null
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: tensp,
                decoration: InputDecoration(
                  labelText: 'Tên sản phẩm',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: soluongsp,
                decoration: InputDecoration(
                  labelText: 'Số lượng sản phẩm',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: dongiasp,
                decoration: InputDecoration(
                  labelText: 'Đơn giá sản phẩm',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: motasp,
                decoration: InputDecoration(
                  labelText: 'Mô tả sản phẩm',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Product add = Product(
                    id: '',
                    name: tensp.text,
                    quantity: soluongsp.text,
                    image: _image?.path ?? '',
                    price: dongiasp.text,
                    mota: motasp.text);
                await newproduct.productAdd(add);
              },
              child: Text('Thêm mới'),
            ),
          ],
        ),
      ),
    );
  }
}
