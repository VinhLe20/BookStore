import 'package:bookstore/Model/product.dart';
import 'package:flutter/material.dart';

class ProductManager extends StatefulWidget {
  const ProductManager({Key? key}) : super(key: key);

  @override
  State<ProductManager> createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
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
        title: const Text('Quản lý sản phẩm'),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      child: Image.network(
                        "https://product.hstatic.net/1000237375/product/2_2d76f54ca66841ab82871ed32452b6cb_master.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          products[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: \$${products[index].price}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: ${products[index].quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  // Widget _Card(Product product) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           alignment: Alignment.center,
  //           width: double.infinity,
  //           height: 150,
  //           child: Image.network(
  //             "https://product.hstatic.net/1000237375/product/2_2d76f54ca66841ab82871ed32452b6cb_master.png",
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         Column(
  //           children: [
  //             const SizedBox(height: 8),
  //             Text(
  //               product.name,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               'Price: \$${product.price}',
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               'Quantity: ${product.quantity}',
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton(
  //               onPressed: () {},
  //               child: Text('View'),
  //             ),
  //             TextButton(
  //               onPressed: () {},
  //               child: Text('Buy Now'),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
