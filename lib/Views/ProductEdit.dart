import 'dart:convert';
import 'dart:io';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProductEdit extends StatefulWidget {
  ProductEdit({super.key, required this.pro});
  var pro;
  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  Product product = Product(
      id: "",
      name: "",
      quantity: "",
      image: "",
      price: "",
      mota: "",
      category: "",
      author: '');
  var tensp = TextEditingController();
  var soluongsp = TextEditingController();
  var dongiasp = TextEditingController();
  var motasp = TextEditingController();
  var tacgia = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  String? selectedCategory;
  List categories = [];
  @override
  void initState() {
    super.initState();
    _loadCategories();
    selectedCategory = widget.pro['category_id'];
  }

  void _loadCategories() {
    loadCategories().then((value) {
      setState(() {
        categories = value;
      });
    });
  }

  Future loadCategories() async {
    final uri = Uri.parse('http://192.168.1.12/getdataCategory.php');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future<void> choiceImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    tensp.text = widget.pro['name'];
    soluongsp.text = widget.pro['quantity'];
    dongiasp.text = widget.pro['price'];
    motasp.text = widget.pro['description'];
    tacgia.text = widget.pro['author'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa phẩm'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductManager()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _image == null
                      ? Image.network(
                          "http://192.168.1.4/uploads/${widget.pro['image']}")
                      : Image.file(File(_image!.path), fit: BoxFit.cover),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                controller: tensp,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: tacgia,
                decoration: const InputDecoration(
                  labelText: 'Tác giả',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Thể loại sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((var category) {
                  return DropdownMenuItem(
                    value: category['id'].toString(),
                    child: Text(category['name']),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: soluongsp,
                decoration: const InputDecoration(
                  labelText: 'Số lượng sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: dongiasp,
                decoration: const InputDecoration(
                  labelText: 'Đơn giá sản phẩm',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: motasp,
                decoration: const InputDecoration(
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
                    image: _image?.path ?? "",
                    price: dongiasp.text,
                    mota: motasp.text,
                    category: selectedCategory ?? '',
                    author: tacgia.text);
                try {
                  await product.EditProduct(edit);
                  Fluttertoast.showToast(
                    msg: "Sản phẩm đã được cập nhật",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductManager()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Có lỗi xảy ra: $e'),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Cập nhật sản phẩm'),
            ))
          ],
        ),
      ),
    );
  }
}
