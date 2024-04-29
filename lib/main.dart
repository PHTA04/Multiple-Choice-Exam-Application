import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui/home_teacher.dart';
import 'package:multiple_choice_exam/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:multiple_choice_exam/database/databaseProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const HomeTeacher(),
    );
  }
}