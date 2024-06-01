import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  State<TestScreen> createState() => _TestScreenState();
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

  void endTest() async {
    int totalQuestions = cauHoiList.length;
    double totalScore = 0.0;
    double correctQuestionCount = 0.0;

    int unansweredQuestions = 0;

    for (int i = 0; i < totalQuestions; i++) {
      var dapAnDung = cauHoiList[i]['dapAnDung'];
      List<String> correctAnswersForQuestion;

      if (dapAnDung is Map<String, dynamic>) {
        correctAnswersForQuestion = dapAnDung.values.cast<String>().toList();
      } else if (dapAnDung is Iterable) {
        correctAnswersForQuestion = List<String>.from(dapAnDung);
      } else {
        correctAnswersForQuestion = [];
      }

      List<String>? userAnswersForQuestion = answers[i];

      if (userAnswersForQuestion == null || userAnswersForQuestion.isEmpty) {
        unansweredQuestions++;
      } else {
        int numCorrectAnswers = correctAnswersForQuestion.length;
        int numUserCorrectAnswers = userAnswersForQuestion
            .where((answer) => correctAnswersForQuestion.contains(answer))
            .length;

        if (numCorrectAnswers > 0) {
          double scoreForQuestion = numUserCorrectAnswers / numCorrectAnswers;
          totalScore += scoreForQuestion;

          if (scoreForQuestion == 1.0) {
            correctQuestionCount += 1.0;
          } else {
            correctQuestionCount += scoreForQuestion;
          }
        }
      }
    }

    if (unansweredQuestions > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Có câu hỏi chưa được chọn đáp án"),
            content: const Text(
              "Vui lòng chọn đáp án cho tất cả các câu hỏi trước khi kết thúc bài thi.",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _countDownController.pause();
      String? remainingTimeString = _countDownController.getTime();
      remainingTime = getRemainingTimeInSeconds(remainingTimeString);
      int thoiGianHoanThanhBaiThi = widget.thoiGianLamBai * 60 - remainingTime;

      double finalScore = (totalScore / totalQuestions) * 10;
      DateTime now = DateTime.now();
      String ngayLamBai = now.toIso8601String().split('T')[0];
      String gioLamBai = now.toIso8601String().split('T')[1].split('.')[0];

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
              .collection('SinhVien')
              .doc(user.uid)
              .get();

          if (studentSnapshot.exists) {
            Map<String, dynamic> studentData = studentSnapshot.data() as Map<String, dynamic>;
            String maSoSinhVien = studentData['maSoSinhVien'];

            String maDiem = await DatabaseService.insertDiem(
              widget.maBaiThi,
              maSoSinhVien, // Sử dụng maSoSinhVien từ studentData
              correctQuestionCount,
              totalQuestions - correctQuestionCount,
              thoiGianHoanThanhBaiThi,
              ngayLamBai,
              gioLamBai,
              1, // Replace with the actual number of attempts
            );

            await DatabaseService.insertXemLaiBaiThi(
              cauHoiList.map((cauHoi) => {
                'ndCauHoi': cauHoi['ndCauHoi'],
                'dapAnA': cauHoi['dapAnA'],
                'dapAnB': cauHoi['dapAnB'],
                'dapAnC': cauHoi['dapAnC'],
                'dapAnD': cauHoi['dapAnD'],
                'dapAnE': cauHoi['dapAnE'],
                'dapAnF': cauHoi['dapAnF'],
                'dapAnG': cauHoi['dapAnG'],
                'dapAnH': cauHoi['dapAnH'],
              }).toList(),
              dapAnDungList.map((dapAnDung) => {
                'dapAnDung': dapAnDung,
              }).toList(),
              answers.map((index, dapAnSinhVienChon) => MapEntry(
                index.toString(),
                {
                  'dapAnSinhVienChon': dapAnSinhVienChon,
                },
              )).values.toList(),
              int.parse(maDiem),
            );

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Kết thúc bài thi"),
                  content: Text(
                    "Bạn đã hoàn thành bài thi với ${correctQuestionCount.toStringAsFixed(2)}/$totalQuestions câu đúng.\n"
                        "Điểm của bạn là ${finalScore.toStringAsFixed(2)}/10 điểm.",
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Xem kết quả"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScoreScreen(
                              score: finalScore,
                              correctQuestionCount: correctQuestionCount,
                              totalQuestions: totalQuestions,
                              cauHoiList: cauHoiList,
                              answers: answers,
                              dapAnDungList: dapAnDungList,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            print('Không tìm thấy thông tin sinh viên.');
          }
        } else {
          print('Người dùng không tồn tại.');
        }
      } catch (e) {
        print('Lỗi khi chèn điểm hoặc xem lại bài thi: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Lỗi"),
              content: const Text("Có lỗi xảy ra trong quá trình chèn điểm hoặc xem lại bài thi."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
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
  }

  int getRemainingTimeInSeconds(String? timeString) {
    if (timeString == null) {
      return 0;
    }
    List<String> parts = timeString.split(':');
    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
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
        automaticallyImplyLeading: false,
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
                        minimumSize: const Size(110, 45),
                      ),
                      child: const Text('Quay lại'),
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
                      minimumSize: const Size(110, 45),
                    ),
                    child: Text(currentQuestionIndex < cauHoiList.length - 1 ? 'Tiếp theo' : 'Nộp bài'),
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