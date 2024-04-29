import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewTopic extends StatefulWidget {
  const ViewTopic({super.key});

  @override
  State<ViewTopic> createState() => _ViewTopicState();
}

class _ViewTopicState extends State<ViewTopic> {
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
        "Xem Chủ Đề",
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
