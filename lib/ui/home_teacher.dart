import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseProvider.dart';
import 'package:multiple_choice_exam/ui/create_question.dart';
import 'package:multiple_choice_exam/ui/create_subject.dart';
import 'package:multiple_choice_exam/ui/create_topic.dart';
import 'package:multiple_choice_exam/ui/view_question.dart';
import 'package:multiple_choice_exam/ui/view_subject.dart';
import 'package:multiple_choice_exam/ui/view_topic.dart';
import 'package:provider/provider.dart';

class HomeTeacher extends StatefulWidget {
  const HomeTeacher({super.key});

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _questionBankItem("Tạo Môn Học", Icons.book, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateSubject())
              );
            }),
            _questionBankItem("Xem Môn Học", Icons.view_list, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewSubject())
              );
            }),
            _questionBankItem("Tạo Chủ Đề", Icons.category, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTopic())
              );
            }),
            _questionBankItem("Xem Chủ Đề", Icons.article, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewTopic())
              );
            }),
            _questionBankItem("Tạo Câu Hỏi", Icons.question_answer, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateQuestion())
              );
            }),
            _questionBankItem("Xem Câu Hỏi", Icons.view_quilt, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewQuestion())
              );
            }),
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 10,
      title: const Text(
        "Ngân Hàng Câu Hỏi",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis, // Xử lý văn bản dài
      ),
      leading: GestureDetector(
        onTap: (){
          print("tapped");
        },
        child: const Icon(Icons.nightlight_round, size: 20,),
      ),
      actions: [
        Icon(Icons.person, size: 20,),
        SizedBox(width: 20,)
      ],
    );
  }

  _questionBankItem(String title, IconData icon, Null Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}




