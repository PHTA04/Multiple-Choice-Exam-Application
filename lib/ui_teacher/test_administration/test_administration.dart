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
          children: [
            _testAdministrationItem("Tạo Bài Thi", Icons.book_outlined, (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTest())
              );
            }),
            _testAdministrationItem("Xem Bài Thi", Icons.view_list_outlined, (){
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

  _testAdministrationItem(String title, IconData icon, Null Function() onTap) {
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
