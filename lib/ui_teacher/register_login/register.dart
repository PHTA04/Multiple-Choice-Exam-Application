import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiple_choice_exam/database/firebaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/register_login/sign_in.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isObscure = true;
  bool _isObscure2 = true;

  final TextEditingController hoTenSinhVienController = TextEditingController();
  final TextEditingController maSoSinhVienController = TextEditingController();
  final TextEditingController tenDangNhapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  final TextEditingController nhaplaiMatKhauController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();


  void _register() async {
    final hoTen = hoTenSinhVienController.text;
    final maSoSinhVien = maSoSinhVienController.text;
    final tenDangNhap = tenDangNhapController.text;
    final email = emailController.text;
    final matKhau = matKhauController.text;
    final nhaplaiMatKhau = nhaplaiMatKhauController.text;

    if (matKhau == nhaplaiMatKhau) {
      final studentData = {
        'hoTen': hoTen,
        'maSoSinhVien': maSoSinhVien,
        'tenDangNhap': tenDangNhap,
        'email': email,
      };

      try {
        User? user = await _firebaseService.registerWithEmailAndPassword(email, matKhau);
        if (user != null) {
          await _firebaseService.registerStudent(user, studentData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng ký thành công!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng ký thất bại!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không khớp!')),
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
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40.0),
                      Column(
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            size: 100,
                            color: Colors.white,
                          ),
                          Text(
                            'Tạo Tài Khoản Mới Dành Cho Sinh Viên!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lobster(
                              textStyle: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

                        child: Container(
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
                                        controller: hoTenSinhVienController,
                                        decoration: const InputDecoration(
                                          labelText: 'Họ và Tên',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.person_2_outlined),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),

                                      TextFormField(
                                        controller: maSoSinhVienController,
                                        decoration: const InputDecoration(
                                          labelText: 'Mã số sinh viên',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),

                                      TextFormField(
                                        controller: tenDangNhapController,
                                        decoration: const InputDecoration(
                                          labelText: 'Tên đăng nhập',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.account_circle_outlined),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),

                                      TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.email_outlined),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),

                                      TextFormField(
                                        controller: matKhauController,
                                        decoration: InputDecoration(
                                          labelText: 'Mật khẩu',
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

                                      TextFormField(
                                        controller: nhaplaiMatKhauController,
                                        decoration: InputDecoration(
                                          labelText: 'Nhập lại mật khẩu',
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure2 = !_isObscure2;
                                              });
                                            },
                                          ),
                                        ),
                                        obscureText: _isObscure2,
                                      ),
                                      const SizedBox(height: 20.0),

                                      ElevatedButton(
                                        onPressed: _register,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Text(
                                          'Đăng Ký',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
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
                                                MaterialPageRoute(builder: (context) => const SignIn()),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff01A0C7),
                                            ),
                                            child: const Text(
                                              'Đăng Nhập',
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
            ),
          ],
        ),
      ),
    );
  }
}
