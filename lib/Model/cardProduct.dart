import 'package:bookstore/Views/ProductDetail.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatelessWidget {
  CardProduct({super.key, required this.product});
  var product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(product: product)));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Image.network(
                'http://192.168.1.7:8012/flutter/uploads/${product['hinhanh']}',
                fit: BoxFit.cover,
              ),
            ),
          )),
          const SizedBox(height: 8),
          Text(
            product['ten'],
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Quantity: ${product['soluong']}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product['dongia']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Da ban: 10',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Thêm vào giỏ hàng',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
