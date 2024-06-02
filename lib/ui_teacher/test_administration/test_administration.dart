import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_teacher/test_administration/create_test.dart';
import 'package:multiple_choice_exam/ui_teacher/test_administration/view_test.dart';

class TestAdministration extends StatefulWidget {
  const TestAdministration({super.key});

  @override
  State<TestAdministration> createState() => _TestAdministrationState();
}

class _TestAdministrationState extends State<TestAdministration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child:GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _testAdministrationItem("Tạo Bài Thi", Icons.book_outlined, Colors.redAccent, (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTest())
              );
            }),
            _testAdministrationItem("Xem Bài Thi", Icons.view_list_outlined, Colors.green, (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewTest())
              );
            }),
          ],
        ),
      ),
    );
  }

  _testAdministrationItem(String title, IconData icon, Color color, VoidCallback onTap) {
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
