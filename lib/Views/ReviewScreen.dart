import 'dart:convert';
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
  List data = [];
  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    loadOrder().then(
      (value) {
        setState(() {
          data = value;
          _selectedProductId = data.isNotEmpty ? data[0]['product_id'] : null;
        });
      },
    );
  }

  Future<List> loadOrder() async {
    final uri = Uri.parse('${Host.host}/getdataOrderDetail.php');

    var response = await http.get(uri);
    var data = json.decode(response.body) as List;
    var filteredData = data
        .where((item) => item['order_id'] == widget.order['order_id'])
        .toList();
    return filteredData;
  }

  Future<void> submitReview() async {
    if (_formKey.currentState!.validate() && _selectedProductId != null) {
      final response = await http.post(
        Uri.parse('${Host.host}/submitReview.php'),
        body: {
          'time': '',
          'product_id': _selectedProductId!,
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
                Text('Chọn sản phẩm để đánh giá:',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                if (data.isNotEmpty)
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedProductId,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedProductId = newValue;
                      });
                    },
                    items: data.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['product_id'],
                        child: Text(item['product_name']),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 16),
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
                    onPressed: submitReview,
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
