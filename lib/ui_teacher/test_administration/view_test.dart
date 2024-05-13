import 'package:flutter/material.dart';

class ViewTest extends StatefulWidget {
  const ViewTest({super.key});

  @override
  State<ViewTest> createState() => _ViewTestState();
}

class _ViewTestState extends State<ViewTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Text("data"),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 10,
      title: const Text(
        "Xem Bài Thi",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis, // Xử lý văn bản dài
      ),
    );
  }
}
