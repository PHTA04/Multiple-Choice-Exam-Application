import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseProvider.dart';
import 'package:provider/provider.dart';
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
  bool _isDatabaseConnected = false;

  @override
  void initState() {
    super.initState();
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.connectToDatabase().then((_) {
      setState(() {
        _isDatabaseConnected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDatabaseConnected) {
      return const CircularProgressIndicator();
    }

    final databaseProvider = Provider.of<DatabaseProvider>(context);
    var myDatabase = databaseProvider.database;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: myDatabase.getMonHoc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Hiển thị tiến trình tải
        } else if (snapshot.hasError) {
          return Text('Đã xảy ra lỗi: ${snapshot.error}');
        } else {
          if (updateData) {
            updateData = false; // Nếu dữ liệu đã được cập nhật, reset biến updated và tải lại dữ liệu
            myDatabase.getMonHoc().then((data) {
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(7.0),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 2.0), // Khoảng cách giữa title và subtitle
                      child: Text(
                        maMonHoc,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
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
      backgroundColor: Colors.white,
      elevation: 10,
      title: const Text(
        "Xem Môn Học",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis, // Xử lý văn bản dài
      ),
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
            child: const Text('Delete'),
            onPressed: () {
              deleteMonHoc();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update'),
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
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void deleteMonHoc() {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final myDatabase = databaseProvider.database;
    myDatabase.deleteSubject(selectedMaMonHoc).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }

  void updateMonHoc() {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final myDatabase = databaseProvider.database;
    myDatabase.updateSubject(selectedMaMonHoc, selectedTenMonHoc).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }
}
