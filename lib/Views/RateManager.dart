import 'dart:convert';

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
    final uri = Uri.parse('http://192.168.1.10/getdataComment.php');
    var response = await http.get(uri);
    return json.decode(response.body).toList();
  }

  Future deleteComment(String id) async {
    final uri = Uri.parse('http://192.168.1.10/deleteComment.php');
    http.post(uri, body: {'id': id});
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
                  context, MaterialPageRoute(builder: (context) => Index()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: loadDataComment(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    List? comment = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Người dùng: ${comment?[index]['name']}"),
                              Text(
                                  "Sản phẩm: ${comment?[index]['product_name']}"),
                              Row(
                                children: [
                                  Text("Đánh giá: ${comment?[index]['rate']}"),
                                  Icon(Icons.star, size: 16)
                                ],
                              ),
                              Text(
                                "Nhận xét: ${comment?[index]['comment']}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Container(
                            child: IconButton(
                                onPressed: () {
                                  deleteComment(comment?[index]['id']);
                                },
                                icon: Icon(Icons.delete)),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
