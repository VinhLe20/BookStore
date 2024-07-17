import 'dart:convert';

import 'package:bookstore/Model/host.dart';

import 'package:bookstore/Views/Admin.dart';

import 'package:bookstore/Views/CategoryAdd.dart';
import 'package:bookstore/Views/CategoryEdit.dart';
import 'package:bookstore/Views/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  void confirmdeleteSelected(String id) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Bạn có muốn xóa thể loại đã chọn?',
      confirmBtnText: 'Có',
      cancelBtnText: 'Không',
      confirmBtnColor: Colors.green,
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      onConfirmBtnTap: () async {
        await deleteCategories(id);

        setState(() {});
        Navigator.pop(context);
      },
    );
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
                                        confirmdeleteSelected(
                                            categories[index]['id']);
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
