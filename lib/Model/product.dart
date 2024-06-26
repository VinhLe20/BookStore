import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  String id;
  String name;
  String quantity;
  String price;
  String mota;
  String image;
  Product(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.image,
      required this.price,
      required this.mota});
  List<Product> products = [];

  Future loadProduct() async {
    final uri = Uri.parse('http://192.168.1.7:8012/flutter/getDataProduct.php');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future productAdd(Product pro) async {
    final uri = Uri.parse('http://192.168.1.7:8012/flutter/addProduct.php');
    var request = http.MultipartRequest('POST', uri);
    request.fields['ten'] = pro.name;
    request.fields['soluong'] = pro.quantity;
    request.fields['dongia'] = pro.price;
    request.fields['mota'] = pro.mota;

    if (pro.image.isNotEmpty) {
      var pic = await http.MultipartFile.fromPath("image", pro.image);
      request.files.add(pic);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded");
    } else {
      print("Image not uploaded");
    }
  }

  Future EditProduct(Product pro) async {
    final uri = Uri.parse('http://192.168.1.7:8012/flutter/updateProduct.php');

    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = pro.id;
    request.fields['ten'] = pro.name;
    request.fields['soluong'] = pro.quantity;
    request.fields['dongia'] = pro.price;
    request.fields['mota'] = pro.mota;

    if (pro.image.isNotEmpty) {
      var pic = await http.MultipartFile.fromPath("image", pro.image);
      request.files.add(pic);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded");
    } else {
      print("Image not uploaded");
    }
  }

  Future DeleteProduct(Product pro) async {}
}
