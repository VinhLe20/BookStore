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
  Product pro = Product(
      id: "",
      name: "",
      quantity: "",
      image: "",
      price: "",
      mota: "",
      category: "",
      author: '');
  List filteredProducts = [];
  List products = [];
  String tb = "";
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    pro.loadProduct().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = [];
      });
    } else {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _performSearch() {
    String query = searchController.text.trim();
    _filterProducts(query);
    if (filteredProducts.isEmpty) {
      tb = 'Không tìm thấy sản phẩm này!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Index()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,

            ),
            fillColor: Colors.white.withOpacity(0.1),
          ),

          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            _performSearch();
          },

        ),
        backgroundColor: Colors.green.shade500,
        actions: [
          TextButton(
            onPressed: _performSearch,
            child: const Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: filteredProducts.isEmpty
          ? Center(child: Text("$tb"))
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
            ),
    );
  }
}
