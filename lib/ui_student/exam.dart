import 'package:flutter/material.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Làm bài thi',
        style: TextStyle(fontSize: 24),
      ),
    );

  }
}
