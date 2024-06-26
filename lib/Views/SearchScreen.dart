import 'package:bookstore/Model/cardProduct.dart';
import 'package:bookstore/Model/product.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  Product pro =
      Product(id: "", name: "", quantity: "", image: "", price: "", mota: "");
  List filteredProducts = [];
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
          filteredProducts = products;
        });
      });
    });
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product['ten'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _clearSearch() {
    searchController.clear();
    _filterProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Index()));
              },
              icon: Icon(Icons.arrow_back)),
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white.withOpacity(0.1),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white),
                onPressed: _clearSearch,
              ),
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              _filterProducts(value);
            },
          ),
          backgroundColor: Colors.blue,
        ),
        body: filteredProducts.isEmpty
            ? Center(child: Text('No products found'))
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return CardProduct(product: filteredProducts[index]);
                  },
                ),
              ));
  }
}
