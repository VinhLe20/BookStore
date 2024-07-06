import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  String id;
  String name;
  String category;
  String quantity;
  String price;
  String mota;
  String image;
  String author;
  Product(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.image,
      required this.price,
      required this.mota,
      required this.category,
      required this.author});
  List<Product> products = [];

  Future loadProduct() async {
    final uri = Uri.parse('http://192.168.1.10/getDataProduct.php');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future productAdd(Product pro) async {
    print(pro.category);
    final uri = Uri.parse('http://192.168.1.10/addProduct.php');
    var request = http.MultipartRequest('POST', uri);
    request.fields['ten'] = pro.name;
    request.fields['soluong'] = pro.quantity;
    request.fields['dongia'] = pro.price;
    request.fields['mota'] = pro.mota;
    request.fields['theloai'] = pro.category;
    request.fields['tacgia'] = pro.author;
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
    final uri = Uri.parse('http://192.168.1.10/updateProduct.php');
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = pro.id;
    request.fields['ten'] = pro.name;
    request.fields['soluong'] = pro.quantity;
    request.fields['dongia'] = pro.price;
    request.fields['mota'] = pro.mota;
    request.fields['theloai'] = pro.category;
    request.fields['tacgia'] = pro.author;
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

  Future DeleteProduct(Product pro) async {
    final uri = Uri.parse('http://192.168.1.10/deleteProduct.php');
    http.post(uri, body: {'id': pro.id});
  }
}
