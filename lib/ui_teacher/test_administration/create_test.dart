import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/create_exam.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class CreateTest extends StatefulWidget {
  const CreateTest({super.key});

  @override
  State<CreateTest> createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {

  List<String> tenMonHocList = [];
  String selectedMonHoc = '';

  List<String> tenChuDeList = [];
  String selectedChuDe = '';

  TextEditingController thoiGianLamBaiController = TextEditingController();
  TextEditingController thoiGianBatDauController = MaskedTextController(mask: '00/00/0000');
  TextEditingController thoiGianKetThucController = MaskedTextController(mask: '00/00/0000');
  TextEditingController soLanLamBaiController = TextEditingController();


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
                                  'Môn học mà bạn đã chọn không có đề thi nào. Bạn có muốn chuyển sang trang thêm đề thi không?');
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
                            'Vui lòng chọn tên đề thi',
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

              TextField(
                controller: thoiGianLamBaiController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho phép nhập số
                decoration: InputDecoration(
                  labelText: "Thời gian làm bài thi",
                  hintText: "Nhập thời gian làm bài thi",
                  suffixText: "phút",
                  labelStyle: TextStyle(color: Theme.of(context).hintColor),
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixStyle: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
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

              TextFormField(
                controller: thoiGianBatDauController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Thời gian bắt đầu",
                  hintText: "DD/MM/YYYY",
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Hiển thị lịch khi nhấn vào icon
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {

                        if (selectedDate != null) {
                          if (selectedDate.month < 10) {
                            thoiGianBatDauController.text =
                            "${selectedDate.day}/0${selectedDate.month}/${selectedDate.year}";
                          } else {
                            thoiGianBatDauController.text =
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          }
                        }

                      });
                    },
                    icon: const Icon(Icons.access_time_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: thoiGianKetThucController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Thời gian kết thúc",
                  hintText: "DD/MM/YYYY",
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Hiển thị lịch khi nhấn vào icon
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {

                        if (selectedDate != null) {
                          if (selectedDate.month < 10) {
                            thoiGianKetThucController.text =
                            "${selectedDate.day}/0${selectedDate.month}/${selectedDate.year}";
                          } else {
                            thoiGianKetThucController.text =
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          }
                        }

                      });
                    },
                    icon: const Icon(Icons.access_time_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: soLanLamBaiController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho phép nhập số
                decoration: InputDecoration(
                  labelText: "Số lần làm bài thi",
                  hintText: "Nhập số lần làm bài thi",
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
                child: const Text("Thêm Bài Thi"),
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
        "Tạo Bài Thi",
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
                  MaterialPageRoute(builder: (context) => const CreateExam()));
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
