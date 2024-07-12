import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/CategoryManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  var tentl = TextEditingController();
  Future addCategory(String name) async {
    http.post(Uri.parse('${Host.host}/addCategory.php'), body: {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm thể loại mới',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CategoryManger()));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
                try {
                  await addCategory(tentl.text);
                  Fluttertoast.showToast(
                    msg: "Thêm mới thể loại thành công",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryManger()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Có lỗi xảy ra: $e'),
                  ));
                }
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
