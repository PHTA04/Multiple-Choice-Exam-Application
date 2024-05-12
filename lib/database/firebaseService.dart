import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    try {
      String nameImage = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child(nameImage);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
}
