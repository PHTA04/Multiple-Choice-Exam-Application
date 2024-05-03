import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/ui/create_topic.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({super.key});

  @override
  State<CreateQuestion> createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  List<String> tenMonHocList = []; // Danh sách tên môn học
  String selectedMonHoc = ''; // Môn học được chọn

  List<String> tenChuDeList = [];
  String selectedChuDe = '';

  List<String> loaiCauHoiList = [
    'Câu Hỏi 1 Đáp Án Đúng',
    'Câu Hỏi Nhiều Đáp Án Đúng',
    'Câu Hỏi Đúng Sai'
  ];
  String selectedLoaiCauHoi = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<String>>(
              future: DatabaseService.getTenMonHocList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
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
                        value: selectedMonHoc.isNotEmpty ? selectedMonHoc : null,
                        onChanged: (String? selected) async {
                          setState(() {
                            selectedMonHoc = selected!;
                          });

                          List<String> topicList = await DatabaseService.getTenChuDeList(selected!);

                          if (topicList.isEmpty) {
                            _showTopicNullDialog('Môn học mà bạn đã chọn không có chủ đề nào. Bạn có muốn chuyển sang trang thêm chủ đề không?');
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
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
                        value: selectedChuDe.isNotEmpty ? selectedChuDe : null,
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
                    'Vui lòng chọn loại câu hỏi',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  value: selectedLoaiCauHoi.isNotEmpty ? selectedLoaiCauHoi : null,
                  onChanged: (String? selected) {
                    setState(() {
                      selectedLoaiCauHoi = selected!;
                    });
                  },
                  items: loaiCauHoiList.map((String loaiCauHoi) {
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

            ElevatedButton(
                onPressed: () async {

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Thêm Câu Hỏi"))

          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 10,
      title: const Text(
        "Tạo Câu Hỏi",
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTopic()));
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
