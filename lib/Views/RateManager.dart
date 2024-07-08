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
    final uri = Uri.parse('http://192.168.1.8/getdataComment.php');
    var response = await http.get(uri);
    return json.decode(response.body).toList();
  }

  Future deleteComment(String id) async {
    final uri = Uri.parse('http://192.168.1.8/deleteComment.php');
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
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: loadDataComment(),
        builder: (context, snapshot) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Người dùng: ${comment?[index]['name']}"),
                              Text(
                                  "Sản phẩm: ${comment?[index]['product_name']}"),
                              Row(
                                children: [
                                  Text("Đánh giá: ${comment?[index]['rate']}"),
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.yellow,
                                  )
                                ],
                              ),
                              Text(
                                "Nhận xét: ${comment?[index]['comment']}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                bool result = false;
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
                                          onPressed: () {
                                            deleteComment(
                                                comment?[index]['id']);
                                            result = true;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (result) {
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    );
                  },
                )
              : const CircularProgressIndicator();
        },
      ),
    );
  }
}
