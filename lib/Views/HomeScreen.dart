import 'dart:convert';
import 'package:bookstore/Model/cardProduct.dart';
import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Model/user.dart';
import 'package:bookstore/Views/Cart.dart';
import 'package:bookstore/Views/CategoryManager.dart';
import 'package:bookstore/Views/ImagesSlider.dart';
import 'package:bookstore/Views/LoginScreen.dart';

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
  final List<String> imageAssetPaths = [
    'assets/images/slider1.png',
    'assets/images/slider2.png',
    'assets/images/slider3.png',
  ];
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
    final uri = Uri.parse('${Host.host}/getdataProductSell.php');

    var response = await http.get(uri);
    return json.decode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Trang chủ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade500,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  print(User.guest);
                  !User.guest
                      ? Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Cart()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Loginscreen()));
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ImageSlider(imageAssetPaths: imageAssetPaths),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Sách bán chạy nhất",
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
                    Text("Sách gợi ý",
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
