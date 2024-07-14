import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/firebaseService.dart';
import 'package:multiple_choice_exam/ui_student/home_sinhvien.dart';

class StudentInformation extends StatefulWidget {
  const StudentInformation({super.key});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController hoTenSinhVienController = TextEditingController();
  final TextEditingController maSoSinhVienController = TextEditingController();
  final TextEditingController tenDangNhapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matKhauHienTaiController = TextEditingController();
  final TextEditingController matKhauMoiController = TextEditingController();
  final TextEditingController nhaplaiMatKhauMoiController = TextEditingController();

  bool _isObscureCurrent = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadStudentInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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

              Stack(
                children: [
                  TextFormField(
                    controller: maSoSinhVienController,
                    decoration: const InputDecoration(
                      labelText: 'Mã số sinh viên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                    ),
                    readOnly: true,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.1), // Màu đen bán trong suốt
                    width: double.infinity,
                    height: 67, // Chiều cao của TextFormField
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              Stack(
                children: [
                  TextFormField(
                    controller: tenDangNhapController,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    readOnly: true,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.1), // Màu đen bán trong suốt
                    width: double.infinity,
                    height: 67, // Chiều cao của TextFormField
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              Stack(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.1), // Màu đen bán trong suốt
                    width: double.infinity,
                    height: 67, // Chiều cao của TextFormField
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              TextFormField(
                controller: matKhauHienTaiController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureCurrent = !_isObscureCurrent;
                      });
                    },
                  ),
                ),
                obscureText: _isObscureCurrent,
              ),
              const SizedBox(height: 20.0),

              TextFormField(
                controller: matKhauMoiController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureNew = !_isObscureNew;
                      });
                    },
                  ),
                ),
                obscureText: _isObscureNew,
              ),
              const SizedBox(height: 20.0),

              TextFormField(
                controller: nhaplaiMatKhauMoiController,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                  ),
                ),
                obscureText: _isObscureConfirm,
              ),
              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: _updateStudentInformation,
                child: const Text('Cập nhật thông tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadStudentInformation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic>? studentData = await _firebaseService.getStudentData(user.uid);
      if (studentData != null) {
        setState(() {
          hoTenSinhVienController.text = studentData['hoTen'] ?? '';
          maSoSinhVienController.text = studentData['maSoSinhVien'] ?? '';
          tenDangNhapController.text = studentData['tenDangNhap'] ?? '';
          emailController.text = studentData['email'] ?? '';
        });
      }
    }
  }

  void _updateStudentInformation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final matKhauHienTai = matKhauHienTaiController.text;
      final matKhauMoi = matKhauMoiController.text;
      final nhaplaiMatKhauMoi = nhaplaiMatKhauMoiController.text;

      // Kiểm tra mật khẩu hiện tại
      if (await _firebaseService.verifyCurrentPassword(user.email!, matKhauHienTai)) {
        final updatedData = {
          'hoTen': hoTenSinhVienController.text,
          'email': emailController.text,
        };
        await _firebaseService.updateStudentData(user.uid, updatedData);

        // Cập nhật mật khẩu nếu có
        if (matKhauMoi.isNotEmpty && nhaplaiMatKhauMoi.isNotEmpty) {
          if (matKhauMoi.length < 6 || nhaplaiMatKhauMoi.length < 6) {
            showMessage('Mật khẩu mới và nhập lại mật khẩu phải có ít nhất 6 ký tự!');
          } else if (matKhauMoi == nhaplaiMatKhauMoi) {
            await _firebaseService.updatePassword(user, matKhauMoi);
            showMessage('Cập nhật thông tin và mật khẩu thành công!');
          } else if(matKhauMoi != nhaplaiMatKhauMoi){
            showMessage('Mật khẩu mới không khớp!');
          }
        } else {
          showMessage('Cập nhật thông tin thành công!');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeSinhVien()),
        );
      } else {
        showMessage('Mật khẩu hiện tại không chính xác!');
      }
    }
  }

  void showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
