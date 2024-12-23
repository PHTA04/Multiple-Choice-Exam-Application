import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';

class ViewTopic extends StatefulWidget {
  const ViewTopic({super.key});

  @override
  State<ViewTopic> createState() => _ViewTopicState();
}

class _ViewTopicState extends State<ViewTopic> {
  late List<Map<String, dynamic>> chuDeList;
  String selectMaChuDe = '';
  String selectedTenMonHoc = '';
  String selectedTenChuDe = '';
  List<String> tenMonHocList = [];
  bool updateData = false;
  bool isOpenDialog = false;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          DatabaseService.getTopic(),
          DatabaseService.getTenMonHocList(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            chuDeList = snapshot.data?[0] ?? [];
            tenMonHocList = snapshot.data?[1] ?? [];
            // return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi: ${snapshot.error}');
          } else {
            chuDeList = snapshot.data![0] ?? [];
            tenMonHocList = snapshot.data![1] ?? [];
          }

          return Scaffold(
            appBar: _appBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                itemCount: chuDeList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final maChuDe = chuDeList[index]['maChuDe'].toString();
                  final tenMonHoc = chuDeList[index]['tenMonHoc'];
                  final tenChuDe = chuDeList[index]['tenChuDe'];
                  return Card(
                    elevation: 2,
                      shadowColor: Colors.black54,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(7.0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0), // Khoảng cách giữa title và subtitle
                          child: Text(
                            tenChuDe,
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
                            selectMaChuDe = maChuDe;
                            selectedTenChuDe = tenChuDe;
                            selectedTenMonHoc = tenMonHoc;
                          });
                          showMessage('Chỉnh Sửa Chủ Đề');
                          showEditDialog();
                        },
                      ),
                    )
                  );
                },
              ),
            ),
          );
        }
    );
  }

  _appBar() {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      title: const Text(
        "Xem Chủ Đề",
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
    if (isOpenDialog) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text(
          'Chỉnh sửa chủ đề',
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
                labelText: 'Mã chủ đề',
              ),
              initialValue: selectMaChuDe,
              enabled: false,
            ),

            Expanded(
              flex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Tên môn học",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  DropdownButton2<String>(
                    isDense: false,
                    underline: Container(
                      height: 0.2,
                      color: Colors.black,
                    ),
                    isExpanded: true,
                    hint: Text(
                      selectedTenMonHoc,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    value: selectedTenMonHoc,
                    onChanged: (String? selected) {
                      setState(() {
                        selectedTenMonHoc = selected!;
                      });
                      closeEditDialog();
                      showEditDialog();
                    },
                    items: tenMonHocList.isNotEmpty
                        ? tenMonHocList.map((String monHoc) {
                      return DropdownMenuItem<String>(
                        value: monHoc,
                        child: Text(
                          monHoc,
                          style: const TextStyle(
                            fontSize: 14.2,
                          ),
                        ),
                      );
                    }).toList()
                        : null,
                    buttonStyleData: const ButtonStyleData(
                      // padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 50,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 60,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 300,
                    ),
                  ),
                ],
              ),
            ),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Tên chủ đề',
                hintText: 'Nhập tên chủ đề',
              ),
              onChanged: (value) {
                setState(() {
                  selectedTenChuDe = value;
                });
              },
              controller: TextEditingController(text: selectedTenChuDe),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Xóa'),
            onPressed: () {
              deleteChuDe();
              Navigator.of(context).pop();
              isOpenDialog = false;
            },
          ),
          TextButton(
            child: const Text('Cập Nhật'),
            onPressed: () {
              if(selectedTenChuDe.isEmpty){
                showMessage('Lỗi: Vui lòng nhập Tên chủ đề.');
              } else {
                updateChuDe();
                Navigator.of(context).pop();
                isOpenDialog = false;
              }
            },
          ),
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
              isOpenDialog = false;
            },
          ),
        ],
      ),
    );

    isOpenDialog = true;
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

  void closeEditDialog() {
    if (isOpenDialog) {
      Navigator.of(context).pop();
      isOpenDialog = false;
    }
  }

  void updateChuDe() {
    DatabaseService.updateTopic(selectMaChuDe, selectedTenChuDe, selectedTenMonHoc).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }

  void deleteChuDe() {
    DatabaseService.deleteTopic(selectMaChuDe).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }

}
