import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class imagePicker {
  static String path = "";
  static var imageTemp;
  static String imageNetwork = "";
  Future pickImage() async {
    try {
      final imagePick =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePick == null) return;
      imageTemp = File(imagePick.path);
      path = imagePick.path;
    } catch (e) {
      return e;
    }
  }

  Future<String> uploadImageToFirebase() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      Reference reference =
          FirebaseStorage.instance.ref().child('images/$fileName.png');
      await reference.putFile(imageTemp);
      String downloadURL = await reference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return '';
    }
  }
}
