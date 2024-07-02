import 'dart:convert';

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
    final uri =
        Uri.parse('http://192.168.1.9:8012/flutter/getdataCategory.php');
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  Future deleteCategories(String id) async {
    final uri = Uri.parse('http://192.168.1.9:8012/flutter/deleteCategory.php');
    http.post(uri, body: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý thể loại'),
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Index()));
              },
              icon: Icon(Icons.arrow_back)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CategoryAdd()));
          },
          child: Icon(Icons.add),
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
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () async {
                                        await deleteCategories(
                                            categories[index]['id']);
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : CircularProgressIndicator();
          },
        ));
  }
}
