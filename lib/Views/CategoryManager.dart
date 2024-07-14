import 'dart:convert';

import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/Admin.dart';
import 'package:bookstore/Views/CategoryAdd.dart';
import 'package:bookstore/Views/CategoryEdit.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryManger extends StatefulWidget {
  const CategoryManger({super.key});

  @override
  State<CategoryManger> createState() => _CategoryMangerState();
}

class _CategoryMangerState extends State<CategoryManger> {
  Future loadCategories() async {
    final uri = Uri.parse('${Host.host}/getdataCategory.php');

    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future deleteCategories(String id) async {
    final uri = Uri.parse('${Host.host}/deleteCategory.php');

    http.post(uri, body: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quản lý thể loại',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green.shade500,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Admin()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const CategoryAdd()));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: FutureBuilder(
          future: loadCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List categories = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Thể loại: ${categories[index]['name']}"),
                            Container(
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryEdit(
                                                        theloai: categories[
                                                            index])));
                                      },
                                      icon: const Icon(Icons.edit)),
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
                                              content:
                                                  const SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                        'Bạn có chắc chắn muốn xóa thể loại này không?'),
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
                                                    deleteCategories(
                                                        categories[index]
                                                            ['id']);
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
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const CircularProgressIndicator();
          },
        ));
  }
}
