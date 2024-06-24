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
            TextButton(
                onPressed: () async {
                  await choiceImage();
                  setState(() {
                    chon = true;
                  });
                },
                child: Text('tai anh')),
            Container(
              width: 100,
              height: 100,
              child: !chon
                  ? Image.network(
                      "http://192.168.1.9:8012/flutter/uploads/${widget.pro['hinhanh']}")
                  : _image == null
                      ? null
                      : Image.file(File(_image!.path), fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: tensp,
                decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
            ),
            TextButton(onPressed: () async {}, child: Text('Cập nhật sản phẩm'))
          ],
        ),
      ),
    );
  }
}
