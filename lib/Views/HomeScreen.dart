import 'dart:convert';
import 'package:bookstore/Model/cardProduct.dart';
import 'package:bookstore/Model/product.dart';
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
  bool drawer = true;
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
    final uri =
        Uri.parse('http://192.168.1.22:8012/flutter/getdataProductSell.php');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    print(productsell.length);
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
                icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
          ],
        ),
        drawer: drawer
            ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        // image: DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: AssetImage(
                        //       'assets/header_background.jpg'), // Add a background image if you want
                        // ),
                      ),
                      child: Text(
                        "Quản lý cửa hàng",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.orange),
                      title: const Text(
                        "Quản lý sản phẩm",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductManager()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.people, color: Colors.orange),
                      title: const Text(
                        "Quản lý đơn hàng",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OderManager()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category, color: Colors.orange),
                      title: const Text(
                        "Quản lý thể loại",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategoryManger()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category, color: Colors.orange),
                      title: const Text(
                        "Quản lý đánh giá nhận xét",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RateManager()));
                      },
                    ),
                  ],
                ),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Text(
                    'Khuyến Mãi Lớn Hè 2024 - Giảm Giá Lên Đến 50%!',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                    textAlign: TextAlign.center,
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
                  ? const Center(child: CircularProgressIndicator())
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
