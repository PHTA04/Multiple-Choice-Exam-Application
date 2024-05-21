import 'package:flutter/material.dart';
import 'dart:async';

import 'package:multiple_choice_exam/database/databaseService.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {

  List<Map<String, dynamic>> openTests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOpenTests();
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
              subtitle: Text(
                  'Thời gian làm bài: ${test['thoiGianLamBai']} phút'),
              trailing: ElevatedButton(
                onPressed: () {
                  print('Bắt đầu bài thi: ${test['tenBaiThi']}');
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

      List<Map<String, dynamic>> filteredTests = tests.where((test) {
        DateTime ngayBatDau = DateTime.parse(test['ngayBatDau']);
        DateTime ngayKetThuc = DateTime.parse(test['ngayKetThuc']);
        TimeOfDay gioBatDau = TimeOfDay(
            hour: int.parse(test['gioBatDau'].split(':')[0]),
            minute: int.parse(test['gioBatDau'].split(':')[1]));
        TimeOfDay gioKetThuc = TimeOfDay(
            hour: int.parse(test['gioKetThuc'].split(':')[0]),
            minute: int.parse(test['gioKetThuc'].split(':')[1]));

        DateTime startTime = DateTime(ngayBatDau.year, ngayBatDau.month,
            ngayBatDau.day, gioBatDau.hour, gioBatDau.minute);
        DateTime endTime = DateTime(ngayKetThuc.year, ngayKetThuc.month,
            ngayKetThuc.day, gioKetThuc.hour, gioKetThuc.minute);

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

}
