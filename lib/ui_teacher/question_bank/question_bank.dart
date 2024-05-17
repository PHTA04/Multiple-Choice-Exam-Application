import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/exam_management.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/create_question.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/create_subject.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/create_topic.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/view_question.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/view_subject.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/view_topic.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/sign_in.dart';
import 'package:multiple_choice_exam/ui_teacher/score_management/score_management.dart';
import 'package:multiple_choice_exam/ui_teacher/test_administration/test_administration.dart';

class QuestionBank extends StatefulWidget {
  const QuestionBank({super.key});

  @override
  State<QuestionBank> createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const QuestionBankPage(),
    const ExamManagement(),
    const TestAdministration(),
    const ScoreManagement(),
    // const SignIn(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200], // Màu nền của bottom navigation bar
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Ngân Hàng Câu Hỏi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Quản Lý Đề Thi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Quản Lý Bài Thi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Quản Lý Điểm',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.logout),
          //   label: 'Đăng Xuất',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 10,
      title: Text(
        _appBarTitle(), // Sử dụng phương thức để đặt tiêu đề tương ứng với màn hình
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
      leading: GestureDetector(
        onTap: () {
          print("tapped");
        },
        child: const Icon(
          Icons.nightlight_round,
          size: 20,
        ),
      ),
      actions: const [
        Icon(
          Icons.person,
          size: 20,
        ),
        SizedBox(width: 20)
      ],
    );
  }

  String _appBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Ngân Hàng Câu Hỏi";
      case 1:
        return "Quản Lý Đề Thi";
      case 2:
        return "Quản Lý Bài Thi";
      case 3:
        return "Quản Lý Điểm";
      // case 4:
      //   return "Đăng Xuất";
      default:
        return "Ngân Hàng Câu Hỏi";
    }
  }
}

class QuestionBankPage extends StatelessWidget {
  const QuestionBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          _questionBankItem("Tạo Môn Học", Icons.book, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateSubject()),
            );
          }),
          _questionBankItem("Xem Môn Học", Icons.view_list, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewSubject()),
            );
          }),
          _questionBankItem("Tạo Chủ Đề", Icons.category, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTopic()),
            );
          }),
          _questionBankItem("Xem Chủ Đề", Icons.article, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewTopic()),
            );
          }),
          _questionBankItem("Tạo Câu Hỏi", Icons.question_answer, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateQuestion()),
            );
          }),
          _questionBankItem("Xem Câu Hỏi", Icons.view_quilt, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewQuestion()),
            );
          }),
        ],
      ),
    );
  }

  _questionBankItem(String title, IconData icon, Null Function() onTap) {
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
