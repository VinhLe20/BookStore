import 'dart:convert';
import 'package:bookstore/Model/cardProduct.dart';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/Cart.dart';
import 'package:bookstore/Views/CategoryManager.dart';
import 'package:bookstore/Views/OderManager.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:bookstore/Views/RateManager.dart';
import 'package:bookstore/Views/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Product pro = Product(
      id: "",
      name: "",
      quantity: "",
      image: "",
      price: "",
      mota: '',
      category: '',
      author: '');

  List products = [];
  List productsell = [];
  @override
  void initState() {
    super.initState();
    _loadData();
    _loadSellProduct();
    checkUserInCart();
    getOrderID();
  }

  void _loadData() {
    pro.loadProduct().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  void _loadSellProduct() {
    loadSellProduct().then((value) {
      setState(() {
        productsell = value;
      });
    });
  }

  Future loadSellProduct() async {
    final uri = Uri.parse('http://192.168.1.12/getdataProductSell.php');

    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future<void> getOrderID() async {
    try {
      String id = await User.loadoderid(User.id);
      User.order_id = id;
      print('Order ID: ${User.order_id}');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkUserInCart() async {
    try {
      bool userExistsInCart = await User.isUserIdInCart(User.id);
      if (userExistsInCart) {
        print('User ID ${User.id} is in the cart.');
        await getOrderID();
      } else {
        print('User ID ${User.id} is not in the cart.');
        await addCart();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addCart() async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.12/addCart.php'),
        body: {'id': User.id},
      );
      if (response.statusCode == 200) {
        print('Cart added successfully.');
      } else {
        print('Failed to add cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trang chủ'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                },
                icon: Icon(Icons.shopping_cart))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                height: 150.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/anhbia.png",
                      width: 600,
                      height: 700,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Sản phẩm bán chạy nhất",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: productsell.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CardProduct(product: productsell[index]),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Sản phẩm gợi ý",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              products.isEmpty
                  ? Text('${products.length}')
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return CardProduct(product: products[index]);
                        },
                      ),
                    )
            ],
          ),
        ));
  }
}
