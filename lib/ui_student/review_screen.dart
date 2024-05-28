import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cauHoiList;
  final Map<int, List<String>> answers;
  final List<List<String>> dapAnDungList;

  const ReviewScreen({
    Key? key,
    required this.cauHoiList,
    required this.answers,
    required this.dapAnDungList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review bài thi'),
      ),
      body: ListView.builder(
        itemCount: cauHoiList.length,
        itemBuilder: (context, index) {
          List<String> correctAnswers = dapAnDungList[index];
          List<String> userAnswers = answers[index] ?? [];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Câu hỏi ${index + 1}: ${cauHoiList[index]['ndCauHoi']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (String option in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'])
                          if (cauHoiList[index]['dapAn$option'] != null && cauHoiList[index]['dapAn$option'] != '')
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              color: correctAnswers.contains(cauHoiList[index]['dapAn$option'])
                                  ? Colors.greenAccent
                                  : userAnswers.contains(cauHoiList[index]['dapAn$option'])
                                  ? Colors.redAccent
                                  : Colors.white,
                              child: Text(
                                cauHoiList[index]['dapAn$option'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Đáp án của bạn: ${userAnswers.join(', ')}',
                      style: const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    Text(
                      'Đáp án đúng: ${correctAnswers.join(', ')}',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
