import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_student/review_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final List<Map<String, dynamic>> cauHoiList;
  final Map<int, List<String>> answers;
  final List<List<String>> dapAnDungList;

  const ScoreScreen({
    Key? key,
    required this.score,
    required this.cauHoiList,
    required this.answers,
    required this.dapAnDungList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả bài thi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Điểm số của bạn: $score%',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(
                      cauHoiList: cauHoiList,
                      answers: answers,
                      dapAnDungList: dapAnDungList,
                    ),
                  ),
                );
              },
              child: const Text('Xem lại bài thi'),
            ),
          ],
        ),
      ),
    );
  }
}
