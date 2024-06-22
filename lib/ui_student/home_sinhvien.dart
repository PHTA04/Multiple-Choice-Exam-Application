import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_student/exam.dart';
import 'package:multiple_choice_exam/ui_student/student_information.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/sign_in.dart';

class HomeSinhVien extends StatefulWidget {
  const HomeSinhVien({super.key});

  @override
  State<HomeSinhVien> createState() => _HomeSinhVienState();
}

class _HomeSinhVienState extends State<HomeSinhVien> {

  int _selectedIndex = 0;
  User? _currentUser;
  String _username = 'Loading...';

  final List<Widget> _pages = [
    const Exam(),
    const StudentInformation(),
  ];

  final List<String> _titles = [
    'Làm bài thi',
    'Thông tin của sinh viên',
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('SinhVien').doc(_currentUser!.uid).get();
      setState(() {
        _username = userDoc['tenDangNhap'] ?? 'User';
      });
    }
  }

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
        elevation: 10,
        centerTitle: true,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Xin chào, $_username!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                  Icons.edit,
                color: Colors.cyan,
              ),
              title: const Text('Làm bài thi'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(
                  Icons.info,
                color: Colors.cyan,
              ),
              title: const Text('Thông tin'),
              onTap: () => _onItemTapped(1),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                  Icons.exit_to_app,
                color: Colors.red,
              ),
              title: const Text('Đăng xuất'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
