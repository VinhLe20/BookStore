import 'package:bookstore/Views/CategoryManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  var tentl = TextEditingController();
  Future addCategory(String name) async {
    http.post(Uri.parse('http://192.168.1.10/addCategory.php'),
        body: {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm thể loại mới'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CategoryManger()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                controller: tentl,
                decoration: InputDecoration(
                  labelText: 'Tên thể loại',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                addCategory(tentl.text);
              },
              child: Text('Thêm mới'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
