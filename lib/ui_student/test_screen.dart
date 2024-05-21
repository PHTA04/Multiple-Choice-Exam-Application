import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multiple_choice_exam/database/databaseService.dart';

class TestScreen extends StatefulWidget {
  final int maBaiThi;

  const TestScreen({Key? key, required this.maBaiThi}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Map<String, dynamic>> cauHoiList = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  Map<int, String> answers = {};

  @override
  void initState() {
    super.initState();
    fetchCauHoiList();
  }

  Future<void> fetchCauHoiList() async {
    try {
      List<Map<String, dynamic>> fetchedCauHoiList = await DatabaseService.getDanhSachCauHoiDeThi(widget.maBaiThi);
      setState(() {
        cauHoiList = fetchedCauHoiList;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy danh sách câu hỏi: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < cauHoiList.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Handle end of the test
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Kết thúc bài thi"),
            content: Text("Bạn đã hoàn thành bài thi."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void chooseAnswer(String answer) {
    setState(() {
      answers[currentQuestionIndex] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Làm bài thi'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : cauHoiList.isEmpty
          ? const Center(
        child: Text(
          'Không có câu hỏi nào cho bài thi này.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu hỏi ${currentQuestionIndex + 1}/${cauHoiList.length}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              cauHoiList[currentQuestionIndex]['ndCauHoi'],
              style: TextStyle(fontSize: 18),
            ),
            if (cauHoiList[currentQuestionIndex]['imageCauHoi'] != null)
              Image.network(cauHoiList[currentQuestionIndex]['imageCauHoi']),
            SizedBox(height: 20),
            Column(
              children: [
                for (String option in ['A', 'B', 'C', 'D'])
                  RadioListTile<String>(
                    title: Text(cauHoiList[currentQuestionIndex]['dapAn$option']),
                    value: cauHoiList[currentQuestionIndex]['dapAn$option'],
                    groupValue: answers[currentQuestionIndex],
                    onChanged: (String? value) {
                      chooseAnswer(value!);
                    },
                  ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    },
                    child: Text('Previous'),
                  ),
                ElevatedButton(
                  onPressed: nextQuestion,
                  child: Text(currentQuestionIndex < cauHoiList.length - 1 ? 'Next' : 'Finish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
