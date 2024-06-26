import 'package:bookstore/Model/cardProduct.dart';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/ProductManagerScreen.dart';
import 'package:bookstore/Views/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Product pro =
      Product(id: "", name: "", quantity: "", image: "", price: "", mota: '');
  bool drawer = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      pro.loadProduct().then((value) {
        setState(() {
          products = value;
        });
      });
    });
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
          ],
        ),
        drawer: drawer
            ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
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
                      leading: Icon(Icons.shopping_cart, color: Colors.orange),
                      title: Text(
                        "Quản lý sản phẩm",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductManager()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people, color: Colors.orange),
                      title: Text(
                        "Quản lý thành viên",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Handle the tap event
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.orange),
                      title: Text(
                        "Cài đặt",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Handle the tap event
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help, color: Colors.orange),
                      title: Text(
                        "Trợ giúp",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Handle the tap event
                      },
                    ),
                  ],
                ),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.all(8.0),
              //   height: 200.0,
              //   decoration: BoxDecoration(
              //     color: Colors.blue,
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: Center(
              //     child: Text(
              //       'Khuyến Mãi Lớn Hè 2024 - Giảm Giá Lên Đến 50%!',
              //       style: TextStyle(color: Colors.white, fontSize: 20.0),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              products.isEmpty
                  ? Center(child: CircularProgressIndicator())
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
