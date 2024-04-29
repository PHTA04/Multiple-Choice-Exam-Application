import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewQuestion extends StatefulWidget {
  const ViewQuestion({super.key});

  @override
  State<ViewQuestion> createState() => _ViewQuestionState();
}

class _ViewQuestionState extends State<ViewQuestion> {
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
        "Xem Câu Hỏi",
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
