import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/create_exam.dart';
import 'package:intl/intl.dart';

class ViewTest extends StatefulWidget {
  const ViewTest({super.key});

  @override
  State<ViewTest> createState() => _ViewTestState();
}

class _ViewTestState extends State<ViewTest> {

  List<String> tenMonHocList = [];
  String selectedMonHoc = '';

  List<String> tenDeThiList = [];
  String selectedDeThi = '';

  List<Map<String, dynamic>> baiThiList = [];

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
                              selectedDeThi = '';
                            });

                            List<String> examList =
                            await DatabaseService.getTenDeThiList(
                                selected!);

                            if (examList.isEmpty) {
                              _showExamNullDialog(
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
                future: DatabaseService.getTenDeThiList(selectedMonHoc),
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
                          selectedDeThi.isNotEmpty ? selectedDeThi : null,
                          onChanged: (String? selected) async {
                            setState(() {
                              selectedDeThi = selected!;
                            });

                            List<Map<String, dynamic>> tests =
                                await DatabaseService.getTestByExam(selectedDeThi);

                            setState(() {
                              baiThiList = tests;
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

              baiThiList != null
                  ? GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3/1.7,
                ),
                itemCount: baiThiList.length,
                itemBuilder: (context, index) {
                  final baiThi = baiThiList[index];
                  DateTime ngayBatDau = DateTime.parse(baiThi['ngayBatDau']);
                  DateTime ngayKetThuc = DateTime.parse(baiThi['ngayKetThuc']);
                  String ngayBatDauFormatted = DateFormat('dd/MM/yyyy').format(ngayBatDau);
                  String ngayKetThucFormatted = DateFormat('dd/MM/yyyy').format(ngayKetThuc);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tên bài thi: ${baiThi['tenBaiThi']}'),
                          Text('Thời gian làm bài: ${baiThi['thoiGianLamBai']} phút'),
                          Text('Ngày bắt đầu: $ngayBatDauFormatted'),
                          Text('Ngày kết thúc: $ngayKetThucFormatted'),
                          Text('Giờ bắt đầu: ${baiThi['gioBatDau']}'),
                          Text('Giờ kết thúc: ${baiThi['gioKetThuc']}'),
                          Text('Số lần làm bài: ${baiThi['soLanLamBai']}'),
                          Text('Cho phép xem lại: ${baiThi['choPhepXemLai']}'),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Text("Không có bài thi nào trong đề thi này!"),

            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      title: const Text(
        "Xem Bài Thi",
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

  void _showExamNullDialog(String message) {
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
