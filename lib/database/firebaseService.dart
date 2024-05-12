import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<String> insertImage(String imageUrl) async {
    try {
      // Tạo một ID ngẫu nhiên cho ảnh
      String idImage = _firestore.collection('imageQuestion').doc().id;

      // Thêm dữ liệu vào Firestore
      await _firestore.collection('imageQuestion').doc(idImage).set({
        'imageUrl': imageUrl,
        // Bạn có thể thêm các trường dữ liệu khác tại đây nếu cần
      });

      print('Thêm ảnh vào Firebase thành công.');

      // Trả về idImage
      return idImage;
    } catch (e) {
      print('Error adding image data: $e');
      return "Thêm ảnh vào Firebase thất bại.";
    }
  }
}
