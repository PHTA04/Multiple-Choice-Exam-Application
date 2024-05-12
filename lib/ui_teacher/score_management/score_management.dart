import 'package:flutter/material.dart';

class ScoreManagement extends StatefulWidget {
  const ScoreManagement({super.key});

  @override
  State<ScoreManagement> createState() => _ScoreManagementState();
}

class _ScoreManagementState extends State<ScoreManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Text("data"),
      ),
    );
  }

}
