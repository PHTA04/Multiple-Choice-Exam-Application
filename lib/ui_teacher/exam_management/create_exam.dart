import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/create_topic.dart';

class CreateExam extends StatefulWidget {
  const CreateExam({super.key});

  @override
  State<CreateExam> createState() => _CreateExamState();
}

class _CreateExamState extends State<CreateExam> {

  List<String> chucNangList = [
    'Thêm Một Câu Hỏi Mới',
    'Lấy Danh Sách Các Câu Hỏi Trong Chủ Đề',
    'Lấy Ngẫu Nhiên Các Câu Hỏi Trong Chủ Đề'
  ];
  String selectedChucNang = '';

  List<String> tenMonHocList = [];
  String selectedMonHoc = '';

  List<String> tenChuDeList = [];
  String selectedChuDe = '';

  TextEditingController tenDeThiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<List<String>>(
                  future: DatabaseService.getTenMonHocList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tenMonHocList = snapshot.data!;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Vui lòng chọn tên môn học',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value: selectedMonHoc.isNotEmpty
                                ? selectedMonHoc
                                : null,
                            onChanged: (String? selected) async {
                              setState(() {
                                selectedMonHoc = selected!;
                                selectedChuDe = ''; // reset chủ đề khi chọn môn học mới
                              });

                              List<String> topicList =
                              await DatabaseService.getTenChuDeList(
                                  selected!);

                              if (topicList.isEmpty) {
                                _showTopicNullDialog(
                                    'Môn học mà bạn đã chọn không có chủ đề nào. Bạn có muốn chuyển sang trang thêm chủ đề không?');
                              }
                            },
                            items: tenMonHocList.isNotEmpty
                                ? tenMonHocList.map((String monHoc) {
                              return DropdownMenuItem<String>(
                                value: monHoc,
                                child: Text(monHoc),
                              );
                            }).toList()
                                : null,
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 58,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 50,
                            ),
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 350,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<String>>(
                  future: DatabaseService.getTenChuDeList(selectedMonHoc),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tenMonHocList = snapshot.data!;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Vui lòng chọn tên chủ đề',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value:
                            selectedChuDe.isNotEmpty ? selectedChuDe : null,
                            onChanged: (String? selected) {
                              setState(() {
                                selectedChuDe = selected!;
                              });
                            },
                            items: tenMonHocList.isNotEmpty
                                ? tenMonHocList.map((String monHoc) {
                              return DropdownMenuItem<String>(
                                value: monHoc,
                                child: Text(monHoc),
                              );
                            }).toList()
                                : null,
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 58,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 50,
                            ),
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 350,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Vui lòng chọn chức năng',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      value: selectedChucNang.isNotEmpty
                          ? selectedChucNang
                          : null,
                      onChanged: (String? selected) {
                        setState(() {
                          selectedChucNang = selected!;
                        });
                      },
                      items: chucNangList.map((String loaiCauHoi) {
                        return DropdownMenuItem<String>(
                          value: loaiCauHoi,
                          child: Text(loaiCauHoi),
                        );
                      }).toList(),
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 58,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 50,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 350,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: tenDeThiController,
                  decoration: InputDecoration(
                    labelText: "Tên đề thi",
                    hintText: "Nhập tên đề thi",
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {

                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Thêm Đề Thi"),
                ),

              ],
            ),
          ),
        ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 10,
      title: const Text(
        "Tạo Đề Thi",
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

  void _showTopicNullDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Thông Báo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateTopic()));
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Có'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Không'),
          ),
        ],
      ),
    );
  }
}
