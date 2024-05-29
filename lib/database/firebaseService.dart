import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      String idImage = _firestore.collection('imageQuestion').doc().id; // Tạo một ID ngẫu nhiên cho ảnh
      await _firestore.collection('imageQuestion').doc(idImage).set({ // Thêm dữ liệu vào Firestore
        'imageUrl': imageUrl,
      });
      print('Thêm ảnh vào Firebase thành công.');
      return idImage;
    } catch (e) {
      print('Error adding image data: $e');
      return "Thêm ảnh vào Firebase thất bại.";
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error registering user: $e');
      return null;
    }
  }

  Future<void> registerStudent(User user, Map<String, dynamic> studentData) async {
    try {
      await _firestore.collection('SinhVien').doc(user.uid).set(studentData);
      print('Đăng ký sinh viên thành công.');
    } catch (e) {
      print('Error registering student: $e');
    }
  }

  Future<String?> getEmailByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('SinhVien')
          .where('tenDangNhap', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['email'] as String?;
      } else {
        QuerySnapshot querySnapshotGV = await _firestore
            .collection('GiaoVien')
            .where('tenDangNhap', isEqualTo: username)
            .get();

        if (querySnapshotGV.docs.isNotEmpty) {
          return querySnapshotGV.docs.first['email'] as String?;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching email by username: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailOrUsername(String emailOrUsername, String password) async {
    try {
      String? email = emailOrUsername.contains('@') ? emailOrUsername : await getEmailByUsername(emailOrUsername);
      if (email != null) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      } else {
        print('No user found with the provided username.');
        return null;
      }
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<String?> getUserType(String uid) async {
    try {
      DocumentSnapshot studentDoc = await _firestore.collection('SinhVien').doc(uid).get();
      if (studentDoc.exists) {
        return 'SinhVien';
      }
      DocumentSnapshot teacherDoc = await _firestore.collection('GiaoVien').doc(uid).get();
      if (teacherDoc.exists) {
        return 'GiaoVien';
      }
      return null;
    } catch (e) {
      print('Error fetching user type: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStudentData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('SinhVien').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting student data: $e');
      return null;
    }
  }

  Future<void> updateStudentData(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('SinhVien').doc(uid).update(updatedData);
      print('Cập nhật thông tin sinh viên thành công.');
    } catch (e) {
      print('Error updating student data: $e');
    }
  }

  Future<void> updatePassword(User user, String newPassword) async {
    try {
      await user.updatePassword(newPassword);
      print('Cập nhật mật khẩu thành công.');
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  Future<bool> verifyCurrentPassword(String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      UserCredential userCredential = await _auth.currentUser!.reauthenticateWithCredential(credential);
      return userCredential.user != null;
    } catch (e) {
      print('Error verifying current password: $e');
      return false;
    }
  }

}
