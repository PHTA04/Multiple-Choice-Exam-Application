import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiple_choice_exam/database/databaseProvider.dart';
import 'package:provider/provider.dart';

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

    return FutureBuilder(
        future: Future.wait([
          myDatabase.getChuDe(),
          myDatabase.getTenMonHocList(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
      backgroundColor: Colors.white,
      elevation: 10,
      title: const Text(
        "Xem Chủ Đề",
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
    if (isOpenDialog) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text(
          'Chỉnh sửa môn học',
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
            child: const Text('Delete'),
            onPressed: () {
              deleteChuDe();
              Navigator.of(context).pop();
              isOpenDialog = false;
            },
          ),
          TextButton(
            child: const Text('Update'),
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
            child: const Text('Cancel'),
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

  void closeEditDialog() {
    if (isOpenDialog) {
      Navigator.of(context).pop();
      isOpenDialog = false;
    }
  }

  void updateChuDe() {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final myDatabase = databaseProvider.database;
    myDatabase.updateTopic(selectMaChuDe, selectedTenChuDe, selectedTenMonHoc).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }

  void deleteChuDe() {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final myDatabase = databaseProvider.database;
    myDatabase.deleteTopic(selectMaChuDe).then((message) {
      showMessage(message);
      setState(() {
        updateData = true;
      });
    });
  }

}
