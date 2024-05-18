import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                          decoration: const InputDecoration(
                            labelText: 'Họ và Tên',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_2_outlined),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Mã số sinh viên',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Tên đăng nhập',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.account_circle_outlined),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        TextFormField(
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
                          decoration: InputDecoration(
                            labelText: 'Nhập lại mật khẩu',
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
                          onPressed: () {

                          },
                          child: const Text('Đăng Ký'),
                        ),
                        const SizedBox(height: 10.0),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
