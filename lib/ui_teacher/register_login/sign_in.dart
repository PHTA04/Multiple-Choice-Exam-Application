import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/firebaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/question_bank.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/register.dart';
import 'package:multiple_choice_exam/ui_student/home_sinhvien.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _isObscure = true;

  final TextEditingController tenDangNhapOrEmailController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  void _signIn() async {
    final tenDangNhapOrEmail = tenDangNhapOrEmailController.text;
    final matKhau = matKhauController.text;

    try {
      User? user = await _firebaseService.signInWithEmailOrUsername(tenDangNhapOrEmail, matKhau);
      if (user != null) {
        String? userType = await _firebaseService.getUserType(user.uid);
        if (userType == 'SinhVien') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeSinhVien()),
          );
        } else if (userType == 'GiaoVien') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const QuestionBank()),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.cyanAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80.0),
                    Column(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 100,
                          color: Colors.white,
                        ),
                        Text(
                          'Xin Chào!',
                          style: GoogleFonts.lobster(
                            textStyle: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tenDangNhapOrEmailController,
                              decoration: const InputDecoration(
                                labelText: 'Tên Đăng Nhập hoặc Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.account_circle_outlined),
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            TextFormField(
                              controller: matKhauController,
                              decoration: InputDecoration(
                                labelText: 'Mật Khẩu',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isObscure,
                            ),
                            const SizedBox(height: 20.0),

                            ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                'Đăng Nhập',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        height: 20,
                                        thickness: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('hoặc'),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        height: 20,
                                        thickness: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Register()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff01A0C7),
                                  ),
                                  child: const Text(
                                    'Tạo Tài Khoản Mới',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
