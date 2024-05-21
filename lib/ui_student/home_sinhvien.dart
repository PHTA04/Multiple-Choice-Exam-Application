import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_student/exam.dart';
import 'package:multiple_choice_exam/ui_student/exam_result.dart';
import 'package:multiple_choice_exam/ui_student/student_information.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/sign_in.dart';

class HomeSinhVien extends StatefulWidget {
  const HomeSinhVien({super.key});

  @override
  State<HomeSinhVien> createState() => _HomeSinhVienState();
}

class _HomeSinhVienState extends State<HomeSinhVien> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Exam(),
    const StudentInformation(),
    const ExamResult(),
  ];

  final List<String> _titles = [
    'Làm bài thi',
    'Thông tin của sinh viên',
    'Xem kết quả',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Làm bài thi'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Thông tin'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Xem kết quả'),
              onTap: () => _onItemTapped(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Đăng xuất'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
