import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(20.0),
        child: const Text("data"),
      ),
    );
  }

}
