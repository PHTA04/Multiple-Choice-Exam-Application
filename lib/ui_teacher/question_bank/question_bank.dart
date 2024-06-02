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
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      automaticallyImplyLeading: false, // Tắt nút leading (back)
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        _appBarTitle(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );
          },
        ),
        const SizedBox(width: 20)
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.question_answer_outlined, 0),
          label: 'Ngân Hàng Câu Hỏi',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.admin_panel_settings_outlined, 1),
          label: 'Quản Lý Đề Thi',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.assignment_outlined, 2),
          label: 'Quản Lý Bài Thi',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.score_outlined, 3),
          label: 'Quản Lý Điểm',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      showUnselectedLabels: true,
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: isSelected ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ]
            : [],
      ),
      child: Icon(
        icon,
        size: isSelected ? 25 : 22,
        color: isSelected ? Colors.white : Colors.grey,
      ),
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
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _questionBankItem("Tạo Môn Học", Icons.book_outlined, Colors.purple, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateSubject()),
            );
          }),
          _questionBankItem("Xem Môn Học", Icons.view_list_outlined, Colors.teal, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewSubject()),
            );
          }),
          _questionBankItem("Tạo Chủ Đề", Icons.category_outlined, Colors.orange, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTopic()),
            );
          }),
          _questionBankItem("Xem Chủ Đề", Icons.article_outlined, Colors.redAccent, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewTopic()),
            );
          }),
          _questionBankItem("Tạo Câu Hỏi", Icons.question_answer_outlined, Colors.blue, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateQuestion()),
            );
          }),
          _questionBankItem("Xem Câu Hỏi", Icons.view_quilt_outlined, Colors.green, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewQuestion()),
            );
          }),
        ],
      ),
    );
  }

  Widget _questionBankItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.6), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
