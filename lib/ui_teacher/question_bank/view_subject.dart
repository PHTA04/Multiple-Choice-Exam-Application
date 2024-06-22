import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewSubject extends StatefulWidget {
  const ViewSubject({super.key});

  @override
  State<ViewSubject> createState() => _ViewSubjectState();
}

class _ViewSubjectState extends State<ViewSubject> {
  late List<Map<String, dynamic>> monHocList;
  String selectedMaMonHoc = '';
  String selectedTenMonHoc = '';
  bool updateData = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService.getSubject(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          monHocList = snapshot.data ?? [];
          // return const CircularProgressIndicator(); // Hiển thị tiến trình tải
        } else if (snapshot.hasError) {
          return Text('Đã xảy ra lỗi: ${snapshot.error}');
        } else {
          if (updateData) {
            updateData = false; // Nếu dữ liệu đã được cập nhật, reset biến updated và tải lại dữ liệu
            DatabaseService.getSubject().then((data) {
              setState(() {
                monHocList = data ?? [];
              });
            });
          } else {
            monHocList = snapshot.data ?? [];
          }
        }

        return Scaffold(
          appBar: _appBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.separated(
              itemCount: monHocList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final maMonHoc = monHocList[index]['maMonHoc'];
                final tenMonHoc = monHocList[index]['tenMonHoc'];
                return Card(
                    elevation: 2,
                    shadowColor: Colors.black54,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(9.0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0), // Khoảng cách giữa title và subtitle
                          child: Text(
                            maMonHoc,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        subtitle: Text(tenMonHoc),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        onTap: () {
                          setState(() {
                            selectedMaMonHoc = maMonHoc;
                            selectedTenMonHoc = tenMonHoc;
                          });
                          showMessage('Chỉnh Sửa Môn Học');
                          showEditDialog();
                        },
                      ),
                    )
                );
              },
            ),
          ),
        );
      },
    );
  }

  _appBar() {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      title: const Text(
        "Xem Môn Học",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis, // Xử lý văn bản dài
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  void showEditDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Nhấn bên ngoài Dialog sẽ không bị tắt
      builder: (_) => AlertDialog(
        title: const Text(
          'Chỉnh Sửa Môn Học',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mã môn học',
              ),
              initialValue: selectedMaMonHoc,
              enabled: false,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tên môn học',
                hintText: 'Nhập tên môn học',
              ),
              onChanged: (value) {
                setState(() {
                  selectedTenMonHoc = value;
                });
              },
              controller: TextEditingController(text: selectedTenMonHoc),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Xóa'),
            onPressed: () {
              deleteMonHoc();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cập Nhật'),
            onPressed: () {
              if (selectedTenMonHoc.isEmpty) {
                showMessage('Lỗi: Vui lòng nhập Tên môn học.');
              } else{
                updateMonHoc();
                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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

  void deleteMonHoc() {
    DatabaseService.deleteSubject(selectedMaMonHoc).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }

  void updateMonHoc() {
    DatabaseService.updateSubject(selectedMaMonHoc, selectedTenMonHoc).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }
}
