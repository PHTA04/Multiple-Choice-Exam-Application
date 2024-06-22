import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_student/home_sinhvien.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/question_bank.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/theme.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAyaMKM6EDJ62bAjV4okjcUTJ_DPdEMHxY',
        appId: '1:219326900115:android:975740a96fbd3f3b62aa66',
        messagingSenderId: '219326900115',
        projectId: 'multiple-choice-exam-app',
        storageBucket: 'multiple-choice-exam-app.appspot.com',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.light,
      home: const SignIn(),
    );
  }
}