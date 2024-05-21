import 'package:flutter/material.dart';

class StudentInformation extends StatefulWidget {
  const StudentInformation({super.key});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Thông tin sinh viên',
        style: TextStyle(fontSize: 24),
      ),
    );

  }
}
