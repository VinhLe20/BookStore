import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewScreen extends StatefulWidget {
  ReviewScreen({Key? key, required this.order}) : super(key: key);
  final dynamic order;

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  int _rating = 0;
  var _selectedProduct;

  Future<void> submitReview(String productId) async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${Host.host}/submitReview.php'),
        body: {
          'time': formattedDate,
          'product_id': productId,
          'user_id': User.id,
          'review': _reviewController.text,
          'rating': _rating.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đánh giá đã được gửi thành công!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi đánh giá thất bại. Vui lòng thử lại!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text(
          'Đánh giá đơn hàng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.order is List) ...[
                  Text('Chọn sản phẩm để đánh giá:',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                    value: _selectedProduct,
                    items: widget.order.map<DropdownMenuItem>((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product['product_name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProduct = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn sản phẩm';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn sản phẩm',
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                Text('Đánh giá của bạn:', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập đánh giá của bạn tại đây',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập đánh giá của bạn';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('Đánh giá (từ 1 đến 5):', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                      ),
                      color: Colors.amber,
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.order is List) {
                        if (_selectedProduct != null) {
                          submitReview(_selectedProduct['product_id']);
                        }
                      } else {
                        submitReview(widget.order['product_id']);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      minimumSize: Size(double.infinity, 70),
                    ),
                    child: const Text(
                      'Gửi đánh giá',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}