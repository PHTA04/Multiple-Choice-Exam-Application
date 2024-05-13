import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/create_exam.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/view_exam.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child:GridView.count(
            crossAxisCount: 2,
          children: [
            _examManagementItem("Tạo Đề Thi", Icons.book_outlined, (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateExam())
              );
            }),
            _examManagementItem("Xem Đề Thi", Icons.view_list_outlined, (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewExam())
              );
            }),
          ],
        ),
      ),
    );
  }

  _examManagementItem(String title, IconData icon, Null Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

}
