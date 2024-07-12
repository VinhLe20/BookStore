import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewScreen extends StatefulWidget {
  ReviewScreen({Key? key, required this.order}) : super(key: key);
  var order;
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  int _rating = 0;

  Future<void> submitReview(String product_id) async {
    print(product_id);
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${Host.host}/submitReview.php'),
        body: {
          'time': formattedDate,
          'product_id': product_id,
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
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        for (var element in widget.order) {
                          submitReview(element['product_id']);
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
                                side: const BorderSide(
                                    color: Colors.black, width: 1)),
                            minimumSize: Size(double.infinity, 70))
                        .copyWith(
                      backgroundColor: WidgetStateColor.resolveWith(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white; // Màu nền button khi được nhấn
                          }
                          return Colors.red
                              .shade500; // Sử dụng màu nền mặc định (red.500)
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return null; // Màu chữ button khi được nhấn
                          }
                          return Colors
                              .white; // Sử dụng màu chữ mặc định (white)
                        },
                      ),
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
