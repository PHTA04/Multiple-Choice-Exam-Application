import 'package:flutter/material.dart';

class ExamResult extends StatefulWidget {
  const ExamResult({super.key});

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Kết quả làm bài',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
