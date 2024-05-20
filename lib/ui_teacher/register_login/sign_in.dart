import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/firebaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/question_bank.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/register.dart';
import 'package:multiple_choice_exam/ui_student/home_sinhvien.dart';

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
        color: Colors.white10,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      child: const Text('Đăng Nhập'),
                    ),
                    const SizedBox(height: 10.0),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QuestionBank()),
                            );
                          },
                          child: const Text(
                            'Quên Mật Khẩu?',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                          child: const Text('Tạo Tài Khoản Mới'),
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
    );
  }
}
