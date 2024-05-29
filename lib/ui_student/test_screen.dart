import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:multiple_choice_exam/ui_student/score_screen.dart';

class TestScreen extends StatefulWidget {
  final int maBaiThi;
  final int thoiGianLamBai;

  const TestScreen({super.key, required this.maBaiThi, required this.thoiGianLamBai});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Map<String, dynamic>> cauHoiList = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  Map<int, List<String>> answers = {};
  List<List<String>> dapAnDungList = [];

  final CountDownController _countDownController = CountDownController();
  int remainingTime = 0; // giây

  @override
  void initState() {
    super.initState();
    remainingTime = widget.thoiGianLamBai * 60;
    fetchCauHoiList();
  }

  Future<void> fetchCauHoiList() async {
    try {
      List<Map<String, dynamic>> fetchedCauHoiList = await DatabaseService.getDanhSachCauHoiDeThi(widget.maBaiThi);
      setState(() {
        cauHoiList = fetchedCauHoiList;

        // Lưu trữ danh sách dapAnDung
        dapAnDungList = fetchedCauHoiList.map<List<String>>((cauHoi) {
          var dapAnDung = cauHoi['dapAnDung'];
          if (dapAnDung is Map<String, dynamic>) {
            return dapAnDung.values.cast<String>().toList();
          } else if (dapAnDung is Iterable) {
            return List<String>.from(dapAnDung);
          } else {
            return [];
          }
        }).toList();

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
      endTest();
    }
  }

  void endTest() {
    // Tính toán điểm số
    int totalQuestions = cauHoiList.length;
    int correctAnswers = 0;

    for (int i = 0; i < totalQuestions; i++) {
      var dapAnDung = cauHoiList[i]['dapAnDung'];

      // Debugging information
      print('dapAnDung: ${dapAnDung.runtimeType}');
      print('dapAnDung: ${dapAnDung}');

      List<String> correctAnswersForQuestion;

      // Handle different types of dapAnDung
      if (dapAnDung is Map<String, dynamic>) {
        correctAnswersForQuestion = dapAnDung.values.cast<String>().toList();
      } else if (dapAnDung is Iterable) {
        correctAnswersForQuestion = List<String>.from(dapAnDung);
      } else {
        // Handle unexpected types
        correctAnswersForQuestion = [];
        print('Unexpected type for dapAnDung');
      }

      List<String> userAnswersForQuestion = answers[i] ?? [];

      if (correctAnswersForQuestion.length == userAnswersForQuestion.length &&
          correctAnswersForQuestion.every((element) => userAnswersForQuestion.contains(element))) {
        correctAnswers++;
      }
    }

    int score = ((correctAnswers / totalQuestions) * 100).round();

    // Hiển thị điểm số và điều hướng đến trang xem điểm
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Kết thúc bài thi"),
          content: Text("Bạn đã hoàn thành bài thi với điểm số: $score%"),
          actions: <Widget>[
            TextButton(
              child: const Text("Xem kết quả"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScoreScreen(score: score, cauHoiList: cauHoiList, answers: answers, dapAnDungList: dapAnDungList,),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void chooseAnswer(String answer, bool isMultipleChoice) {
    setState(() {
      List<String> selectedAnswers = answers[currentQuestionIndex] ?? [];

      if (isMultipleChoice) {
        if (selectedAnswers.contains(answer)) {
          selectedAnswers.remove(answer);
        } else {
          selectedAnswers.add(answer);
        }
      } else {
        selectedAnswers = [answer];
      }

      answers[currentQuestionIndex] = selectedAnswers;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMultipleChoice = cauHoiList.isNotEmpty && cauHoiList[currentQuestionIndex]['loaiCauHoi'] == 'Câu Hỏi Nhiều Đáp Án Đúng';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Câu hỏi ${currentQuestionIndex + 1}/${cauHoiList.length}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Handle help button press
            },
          ),
        ],
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Câu hỏi: ${cauHoiList[currentQuestionIndex]['ndCauHoi']} ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: isMultipleChoice
                                      ? '(Chọn nhiều đáp án đúng)'
                                      : '(Chỉ chọn 1 đáp án đúng)',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (cauHoiList[currentQuestionIndex]['imageCauHoi'] != null &&
                              cauHoiList[currentQuestionIndex]['imageCauHoi'].isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.network(cauHoiList[currentQuestionIndex]['imageCauHoi']),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        for (String option in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'])
                          if (cauHoiList[currentQuestionIndex]['dapAn$option'] != null && cauHoiList[currentQuestionIndex]['dapAn$option'] != '')
                            GestureDetector(
                              onTap: () => chooseAnswer(cauHoiList[currentQuestionIndex]['dapAn$option'], isMultipleChoice),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: (answers[currentQuestionIndex]?.contains(cauHoiList[currentQuestionIndex]['dapAn$option']) ?? false)
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  cauHoiList[currentQuestionIndex]['dapAn$option'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: (answers[currentQuestionIndex]?.contains(cauHoiList[currentQuestionIndex]['dapAn$option']) ?? false)
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(110, 45),
                      ),
                      child: const Text('Previous'),
                    ),
                  CircularCountDownTimer(
                    duration: remainingTime,
                    initialDuration: 0,
                    controller: _countDownController,
                    width: 50,
                    height: 50,
                    ringColor: Colors.grey[300]!,
                    ringGradient: null,
                    fillColor: Colors.blueAccent,
                    fillGradient: null,
                    backgroundColor: Colors.white,
                    backgroundGradient: null,
                    strokeWidth: 5.0,
                    strokeCap: StrokeCap.round,
                    textStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textFormat: CountdownTextFormat.MM_SS,
                    isReverse: true,
                    isReverseAnimation: true,
                    isTimerTextShown: true,
                    autoStart: true,
                    onComplete: endTest,
                  ),
                  ElevatedButton(
                    onPressed: nextQuestion,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(110, 45),
                    ),
                    child: Text(currentQuestionIndex < cauHoiList.length - 1 ? 'Next' : 'Finish'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}