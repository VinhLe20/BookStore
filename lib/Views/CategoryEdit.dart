import 'package:bookstore/Model/host.dart';
import 'package:bookstore/Views/CategoryManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CategoryEdit extends StatefulWidget {
  CategoryEdit({super.key, this.theloai});
  var theloai;
  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  var tentl = TextEditingController();
  Future updateCategory(String id, String name) async {
    http.post(Uri.parse('${Host.host}/updateCategory.php'),
        body: {'id': id, 'name': name});
  }

  @override
  Widget build(BuildContext context) {
    tentl.text = widget.theloai['name'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text(
          'Cập nhật thể loại',
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
              padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: TextField(
                controller: tentl,
                decoration: InputDecoration(
                  labelText: 'Tên thể loại',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await updateCategory(widget.theloai['id'], tentl.text);
                    Fluttertoast.showToast(
                      msg: "Thể loại đã được cập nhật",
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
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade500,
                  textStyle: const TextStyle(fontSize: 18),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
