import 'package:bookstore/Model/product.dart';
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
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    pro.loadProduct().then((value) {
      setState(() {
        products = pro.products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: (products.length / 2).ceil(),
              itemBuilder: (context, index) {
                final int firstIndex = index * 2;
                final int secondIndex = firstIndex + 1;
                return Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: _Card(products[firstIndex]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (secondIndex < products.length)
                      Expanded(
                        child: Card(
                          child: _Card(products[secondIndex]),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }

  Widget _Card(Product product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 150,
            child: Image.network(
              "https://product.hstatic.net/1000237375/product/2_2d76f54ca66841ab82871ed32452b6cb_master.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Price: \$${product.price}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quantity: ${product.quantity}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('View'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Buy Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
