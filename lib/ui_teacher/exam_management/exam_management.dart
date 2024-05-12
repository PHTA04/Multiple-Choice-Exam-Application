import 'package:flutter/material.dart';

class ExamManagement extends StatefulWidget {
  const ExamManagement({super.key});

  @override
  State<ExamManagement> createState() => _ExamManagementState();
}

class _ExamManagementState extends State<ExamManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Text("data"),
      ),
    );
  }


}
