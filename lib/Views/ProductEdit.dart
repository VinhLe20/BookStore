import 'dart:io';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductEdit extends StatefulWidget {
  ProductEdit({super.key, required this.pro});
  var pro;
  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  Product product =
      Product(id: "", name: "", quantity: "", image: "", price: "", mota: "");
  var tensp = TextEditingController();
  var soluongsp = TextEditingController();
  var dongiasp = TextEditingController();
  var motasp = TextEditingController();
  bool chon = false;
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
    tensp.text = widget.pro['ten'];
    soluongsp.text = widget.pro['soluong'];
    dongiasp.text = widget.pro['dongia'];
    motasp.text = widget.pro['mota'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa phẩm'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProductManager()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
                onTap: () async {
                  await choiceImage();
                  chon = true;
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
                  child: !chon
                      ? Image.network(
                          "http://192.168.1.7:8012/flutter/uploads/${widget.pro['hinhanh']}")
                      : _image == null
                          ? null
                          : Image.file(File(_image!.path), fit: BoxFit.cover),
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
                Product edit = Product(
                    id: widget.pro['id'],
                    name: tensp.text,
                    quantity: soluongsp.text,
                    image: _image?.path ?? '',
                    price: dongiasp.text,
                    mota: motasp.text);
                await product.EditProduct(edit);
              },
              child: Text('Cập nhật sản phẩm'),
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
