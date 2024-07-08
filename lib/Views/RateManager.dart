import 'dart:convert';

import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RateManager extends StatefulWidget {
  const RateManager({super.key});

  @override
  State<RateManager> createState() => _RateManagerState();
}

class _RateManagerState extends State<RateManager> {
  Future<List> loadDataComment() async {
    final uri = Uri.parse('http://192.168.1.6:8012/getdataComment.php');
    var response = await http.get(uri);
    return json.decode(response.body).toList();
  }

  Future deleteComment(String id) async {
    final uri = Uri.parse('http://192.168.1.10/deleteComment.php');
    await http.post(uri, body: {'id': id});
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
      body: FutureBuilder(
          future: loadDataComment(),
          builder: (context, snapshot) {
            List? comments = snapshot.data;
            return ListView.builder(
              itemCount: comments?.length,
              itemBuilder: (context, index) {
                var comment = comments?[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Người dùng: ${comment['email']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text("Sản phẩm: ${comment['name']}"),
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
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Xác nhận xóa'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Bạn có chắc chắn muốn xóa mục này không?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Hủy'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Xóa'),
                                        onPressed: () async {
                                          await deleteComment(comment['id']);
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
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
          }),
    );
  }
}
