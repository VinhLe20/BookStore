import 'package:firebase_database/firebase_database.dart';

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
  void ProductAdd(String name, String quantity, String price, String mota,
      String image) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    DatabaseReference ref = database.ref('product/$id');
    await ref.set({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": name,
      "quantity": quantity,
      "price": price,
      "mota": mota,
      "image": image
    });
  }

  Future<void> loadProduct() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('product');
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
      map.forEach((key, value) {
        Product product = Product(
            id: value['id'],
            name: value['name'],
            quantity: value['quantity'],
            image: value['image'],
            price: value['price'],
            mota: value['mota']);
        products.add(product);
      });
    }
  }
}
