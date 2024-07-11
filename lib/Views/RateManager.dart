import 'dart:convert';

import 'package:bookstore/Views/Admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RateManager extends StatefulWidget {
  const RateManager({super.key});

  @override
  State<RateManager> createState() => _RateManagerState();
}

class _RateManagerState extends State<RateManager> {
  Future<List<dynamic>> loadDataComment() async {
    final uri = Uri.parse('http://192.168.1.12/getdataComment.php');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Logging the response to understand its structure
      print(data);

      // Check if the response is a list directly or contains an error
      if (data is List) {
        return data;
      } else if (data is Map && data.containsKey('error')) {
        throw Exception(data['error']);
      } else {
        throw Exception('Unexpected JSON structure');
      }
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> deleteComment(String id) async {
    final uri = Uri.parse('http://192.168.1.12/deleteComment.php');
    await http.post(uri, body: {'id': id});
    setState(() {}); // Refresh the state after deleting a comment
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đánh giá nhận xét'),
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Admin()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadDataComment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments found.'));
          } else {
            List<dynamic> comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var comment = comments[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Người dùng: ${comment['user_name']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text("Sản phẩm: ${comment['product_name']}"),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Đánh giá: ${comment['rate']}"),
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Nhận xét: ${comment['comment']}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async {
                              await deleteComment(comment['comment_id']);
                              setState(
                                  () {}); // Refresh the state after deleting a comment
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
