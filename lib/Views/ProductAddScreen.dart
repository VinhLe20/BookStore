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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () async {
                  await choiceImage();
                },
                child: Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _image == null
                      ? Center(
                          child: Text('Thêm ảnh',
                              style: TextStyle(color: Colors.grey[600])))
                      : Image.file(_image!, fit: BoxFit.cover),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                controller: tensp,
                decoration: InputDecoration(
                  labelText: 'Tên sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: soluongsp,
                decoration: InputDecoration(
                  labelText: 'Số lượng sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: dongiasp,
                decoration: InputDecoration(
                  labelText: 'Đơn giá sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: motasp,
                decoration: InputDecoration(
                  labelText: 'Mô tả sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Center(
                child: ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 16),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
