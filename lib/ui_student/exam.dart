import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/ui_student/test_screen.dart';


class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  List<Map<String, dynamic>> openTests = [];
  bool isLoading = true;

  String? maSoSinhVien;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
    fetchOpenTests();
  }

  Future<void> fetchStudentData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('SinhVien')
          .doc(user.uid)
          .get();
      if (studentSnapshot.exists) {
        Map<String, dynamic> studentData = studentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          maSoSinhVien = studentData['maSoSinhVien'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : openTests.isEmpty
          ? const Center(
        child: Text('Hiện tại không có bài thi nào được mở.'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: openTests.length,
        itemBuilder: (context, index) {
          final test = openTests[index];
          return Card(
            child: ListTile(
              title: Text(test['tenBaiThi']),
              subtitle: Text('Thời gian làm bài: ${test['thoiGianLamBai']} phút'),
              trailing: ElevatedButton(
                onPressed: () async {
                  if (maSoSinhVien != null) {
                    int soLanLamBai = await DatabaseService.getSoLanLamBaiSinhVien(
                      maSoSinhVien!,
                      test['maBaiThi'],
                    );

                    print(soLanLamBai);
                    if (soLanLamBai >= test['soLanLamBai']) {
                      _showErrorDialog("Lỗi", "Bạn đã thực hiện quá số lần làm bài.");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestScreen(
                            maBaiThi: test['maBaiThi'],
                            thoiGianLamBai: test['thoiGianLamBai'],
                            soLanLamBai: soLanLamBai,
                            choPhepXemLai: test['choPhepXemLai'],
                          ),
                        ),
                      );
                    }
                  } else {
                    _showErrorDialog("Lỗi", "Không thể lấy thông tin sinh viên.");
                  }
                },
                child: const Text('Bắt đầu'),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchOpenTests() async {
    try {
      List<Map<String, dynamic>> tests = await DatabaseService.getTest();
      DateTime now = DateTime.now();
      print(now);

      List<Map<String, dynamic>> filteredTests = tests.where((test) {
        DateTime ngayBatDau = DateTime.parse(test['ngayBatDau']).toLocal();
        DateTime ngayKetThuc = DateTime.parse(test['ngayKetThuc']).toLocal();
        print('$ngayBatDau - $ngayKetThuc');
        TimeOfDay gioBatDau = TimeOfDay(
            hour: int.parse(test['gioBatDau'].split(':')[0]),
            minute: int.parse(test['gioBatDau'].split(':')[1]));
        TimeOfDay gioKetThuc = TimeOfDay(
            hour: int.parse(test['gioKetThuc'].split(':')[0]),
            minute: int.parse(test['gioKetThuc'].split(':')[1]));
        print('$gioBatDau - $gioKetThuc');

        DateTime startTime = DateTime(ngayBatDau.year, ngayBatDau.month, ngayBatDau.day, gioBatDau.hour, gioBatDau.minute);
        DateTime endTime = DateTime(ngayKetThuc.year, ngayKetThuc.month, ngayKetThuc.day, gioKetThuc.hour, gioKetThuc.minute);
        print('$startTime - $endTime');

        return now.isAfter(startTime) && now.isBefore(endTime);
      }).toList();

      setState(() {
        openTests = filteredTests;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy danh sách bài thi: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(fontSize: 14.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Đóng"),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
