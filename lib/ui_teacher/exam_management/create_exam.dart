import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/database/firebaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/exam_management.dart';
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

  List<String> loaiCauHoiList = [
    'Câu Hỏi 1 Đáp Án Đúng',
    'Câu Hỏi Nhiều Đáp Án Đúng',
    'Câu Hỏi Đúng Sai'
  ];
  String selectedLoaiCauHoi = '';

  List<String> tenMonHocList = [];
  String selectedMonHoc = '';

  List<String> tenChuDeList = [];
  String selectedChuDe = '';

  List<String> noiDungCauHoiList = [];
  Map<String, bool> selectedCauHoi = {};

  TextEditingController tenDeThiController = TextEditingController();

  List<String> selectedQuestionsInExam = [];

  TextEditingController ndCauHoiController = TextEditingController();
  TextEditingController dapAnAController = TextEditingController();
  TextEditingController dapAnBController = TextEditingController();
  TextEditingController dapAnCController = TextEditingController();
  TextEditingController dapAnDController = TextEditingController();
  TextEditingController dapAnEController = TextEditingController();
  TextEditingController dapAnFController = TextEditingController();
  TextEditingController dapAnGController = TextEditingController();
  TextEditingController dapAnHController = TextEditingController();

  TextEditingController dapAnDungController = TextEditingController();
  String? selectedDapAnDung;
  List<String> dapAnDungList = [];
  Map<String, TextEditingController> dapAnDungMap = {};

  List<TextEditingController> danhSachControllers = []; // Danh sách các controller
  int soLuongDapAnDaThem = 2;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  final FirebaseService firebaseService = FirebaseService();

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
                    tenChuDeList = snapshot.data!;
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
                          items: tenChuDeList.isNotEmpty
                              ? tenChuDeList.map((String chuDe) {
                            return DropdownMenuItem<String>(
                              value: chuDe,
                              child: Text(chuDe),
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
                    onChanged:tenChuDeList.isNotEmpty
                        ?
                        (String? selected) async {
                      setState(() {
                        selectedChucNang = selected!;
                      });

                      if (selected == 'Thêm Một Câu Hỏi Mới') {
                        _showAddQuestionDialog();
                      }else  if (selectedChucNang == 'Lấy Danh Sách Các Câu Hỏi Trong Chủ Đề' && selectedChuDe.isNotEmpty) {
                        List<String> cauHoiList = await DatabaseService.getNoiDungCauHoiList(selectedChuDe);
                        setState(() {
                          noiDungCauHoiList = cauHoiList;
                          selectedCauHoi = {
                            for (var cauHoi in cauHoiList) cauHoi: false
                          };
                        });
                      } else if (selectedChucNang == 'Lấy Ngẫu Nhiên Các Câu Hỏi Trong Chủ Đề' && selectedChuDe.isNotEmpty) {
                        _showRandomQuestionDialog();
                      }
                    }
                        : null,
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

              Column(
                children: [
                  if (selectedQuestionsInExam.isNotEmpty) // Thêm điều kiện ở đây
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300, // Màu viền của khung
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12), // Độ bo góc của khung
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Danh sách câu hỏi trong đề thi',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Màu của tiêu đề
                              ),
                              textAlign: TextAlign.center, // Căn giữa tiêu đề
                            ),
                          ),

                          Divider(
                            thickness: 1.0, // Độ dày của đường ngăn cách
                            color: Colors.grey.shade300, // Màu của đường ngăn cách
                            indent: 16.0, // Lề bên trái của đường ngăn cách
                            endIndent: 16.0, // Lề bên phải của đường ngăn cách
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedQuestionsInExam.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(selectedQuestionsInExam[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear_outlined),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Xác nhận xóa"),
                                          content: const Text("Bạn có muốn xóa câu hỏi này khỏi danh sách đề thi không?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Không",
                                                style: TextStyle(color: Colors.grey[800]),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedQuestionsInExam.removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Có",
                                                style:TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),

              ElevatedButton(
                onPressed: () async {

                  if(selectedMonHoc.isEmpty && selectedChuDe.isEmpty && tenDeThiController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn và nhập đầy đủ thông tin.");
                  } else if(selectedMonHoc.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn Tên môn học.");
                  } else if(selectedChuDe.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn Tên chủ đề.");
                  } else if(tenDeThiController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Tên đề thi.");
                  } else {
                    final resultExam = await DatabaseService.insertExam(tenDeThiController.text, selectedMonHoc);
                    print(resultExam);

                    final resultListOfExamQuestion = await DatabaseService.insertListOfExamQuestion(tenDeThiController.text, selectedQuestionsInExam);
                    print(resultListOfExamQuestion);

                    _showSuccessDialog("Đề thi đã được thêm thành công, bạn có muốn thêm đề thi khác không ?");

                    setState(() {
                      tenDeThiController.clear();
                      selectedChucNang = '';
                      noiDungCauHoiList = [];
                      selectedCauHoi = {};
                      selectedQuestionsInExam = [];
                    });
                  }

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Thêm Đề Thi"),
              ),

              const SizedBox(height: 20),

              if (selectedChucNang == 'Lấy Danh Sách Các Câu Hỏi Trong Chủ Đề' && noiDungCauHoiList.isNotEmpty)
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300, // Màu viền của khung
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12), // Độ bo góc của khung
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Danh sách câu hỏi của chủ đề',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Màu của tiêu đề
                              ),
                              textAlign: TextAlign.center, // Căn giữa tiêu đề
                            ),
                          ),
                          Divider(
                            thickness: 1.0, // Độ dày của đường ngăn cách
                            color: Colors.grey.shade300, // Màu của đường ngăn cách
                            indent: 16.0, // Lề bên trái của đường ngăn cách
                            endIndent: 16.0, // Lề bên phải của đường ngăn cách
                          ),
                          Column(
                            children: noiDungCauHoiList.map((cauHoi) {
                              final bool isInExam = selectedQuestionsInExam.contains(cauHoi);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: CheckboxListTile(
                                  title: Text(
                                    cauHoi,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: isInExam ? Colors.grey : Colors.black, // Make text grey if already in exam
                                    ),
                                  ),
                                  value: selectedCauHoi[cauHoi]! && !isInExam,
                                  onChanged: isInExam
                                      ? null // Disable checkbox if question is already in exam
                                      : (bool? value) {
                                    setState(() {
                                      selectedCauHoi[cauHoi] = value ?? false;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              );
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              selectedCauHoi.forEach((cauHoi, isSelected) {
                                if (isSelected && !selectedQuestionsInExam.contains(cauHoi)) {
                                  selectedQuestionsInExam.add(cauHoi);
                                }
                              });
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text("Thêm vào danh sách"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }

  void _showAddQuestionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Thêm Câu Hỏi Mới"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
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
                          value: selectedLoaiCauHoi.isNotEmpty
                              ? selectedLoaiCauHoi
                              : null,
                          onChanged: (String? selected) {
                            setState(() {
                              selectedLoaiCauHoi = selected!;
                              soLuongDapAnDaThem = 2;
                              danhSachControllers.clear();
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

                    TextField(
                      controller: ndCauHoiController,
                      decoration: InputDecoration(
                        labelText: "Nội dung câu hỏi",
                        hintText: "Nhập nội dung câu hỏi",
                        labelStyle: TextStyle(color: Theme.of(context).hintColor),
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 22),
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

                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          selectedImage == null
                              ? GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Center(
                              child: Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                              : Center(
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tải lên hình ảnh câu hỏi",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    if (selectedLoaiCauHoi == 'Câu Hỏi 1 Đáp Án Đúng') ...[
                      _buildAnswerOption('A', dapAnAController, setState),
                      const SizedBox(height: 20),
                      _buildAnswerOption('B', dapAnBController, setState),
                      const SizedBox(height: 20),

                      Column(
                        children:
                        danhSachControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          TextEditingController controller = entry.value;
                          return Column(
                            children: [
                              _buildAnswerOption(
                                  String.fromCharCode(65 + index + 2),
                                  controller, setState), // Bắt đầu từ C
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (soLuongDapAnDaThem < 8) ...[
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (soLuongDapAnDaThem == 2) {
                                    danhSachControllers.add(dapAnCController);
                                  } else if (soLuongDapAnDaThem == 3) {
                                    danhSachControllers.add(dapAnDController);
                                  } else if (soLuongDapAnDaThem == 4) {
                                    danhSachControllers.add(dapAnEController);
                                  } else if (soLuongDapAnDaThem == 5) {
                                    danhSachControllers.add(dapAnFController);
                                  } else if (soLuongDapAnDaThem == 6) {
                                    danhSachControllers.add(dapAnGController);
                                  } else if (soLuongDapAnDaThem == 7) {
                                    danhSachControllers.add(dapAnHController);
                                  }
                                  soLuongDapAnDaThem++;
                                });
                              },
                            ),
                          ],
                          if (soLuongDapAnDaThem > 2) ...[
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (soLuongDapAnDaThem == 3) {
                                    danhSachControllers.remove(dapAnCController);
                                    dapAnCController.clear();
                                  } else if (soLuongDapAnDaThem == 4) {
                                    danhSachControllers.remove(dapAnDController);
                                    dapAnDController.clear();
                                  } else if (soLuongDapAnDaThem == 5) {
                                    danhSachControllers.remove(dapAnEController);
                                    dapAnEController.clear();
                                  } else if (soLuongDapAnDaThem == 6) {
                                    danhSachControllers.remove(dapAnFController);
                                    dapAnFController.clear();
                                  } else if (soLuongDapAnDaThem == 7) {
                                    danhSachControllers.remove(dapAnGController);
                                    dapAnGController.clear();
                                  } else if (soLuongDapAnDaThem == 8) {
                                    danhSachControllers.remove(dapAnHController);
                                    dapAnHController.clear();
                                  }
                                  soLuongDapAnDaThem--;
                                });
                              },
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 20),
                    ]
                    else if (selectedLoaiCauHoi == 'Câu Hỏi Nhiều Đáp Án Đúng') ...[
                      _buildAnswerCheckBox('A', dapAnAController, setState),
                      const SizedBox(height: 20),
                      _buildAnswerCheckBox('B', dapAnBController, setState),
                      const SizedBox(height: 20),
                      _buildAnswerCheckBox('C', dapAnCController, setState),
                      const SizedBox(height: 20),

                      Column(
                        children:
                        danhSachControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          TextEditingController controller = entry.value;
                          return Column(
                            children: [
                              _buildAnswerCheckBox(
                                  String.fromCharCode(65 + index + 3),
                                  controller, setState), // Bắt đầu từ D
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (soLuongDapAnDaThem < 7) ...[
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (soLuongDapAnDaThem == 2) {
                                    danhSachControllers.add(dapAnDController);
                                  } else if (soLuongDapAnDaThem == 3) {
                                    danhSachControllers.add(dapAnEController);
                                  } else if (soLuongDapAnDaThem == 4) {
                                    danhSachControllers.add(dapAnFController);
                                  } else if (soLuongDapAnDaThem == 5) {
                                    danhSachControllers.add(dapAnGController);
                                  } else if (soLuongDapAnDaThem == 6) {
                                    danhSachControllers.add(dapAnHController);
                                  }
                                  soLuongDapAnDaThem++;
                                });
                              },
                            ),
                          ],
                          if (soLuongDapAnDaThem > 2) ...[
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (soLuongDapAnDaThem == 3) {
                                    danhSachControllers.remove(dapAnDController);
                                    dapAnDController.clear();
                                  } else if (soLuongDapAnDaThem == 4) {
                                    danhSachControllers.remove(dapAnEController);
                                    dapAnEController.clear();
                                  } else if (soLuongDapAnDaThem == 5) {
                                    danhSachControllers.remove(dapAnFController);
                                    dapAnFController.clear();
                                  } else if (soLuongDapAnDaThem == 6) {
                                    danhSachControllers.remove(dapAnGController);
                                    dapAnGController.clear();
                                  } else if (soLuongDapAnDaThem == 7) {
                                    danhSachControllers.remove(dapAnHController);
                                    dapAnHController.clear();
                                  }
                                  soLuongDapAnDaThem--;
                                });
                              },
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 20),
                    ]
                    else if (selectedLoaiCauHoi == 'Câu Hỏi Đúng Sai') ...[
                        _buildAnswerOption('A', dapAnAController, setState),
                        const SizedBox(height: 20),
                        _buildAnswerOption('B', dapAnBController, setState),
                        const SizedBox(height: 20),
                      ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Hủy"),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedMonHoc.isEmpty || selectedChuDe.isEmpty || selectedLoaiCauHoi.isEmpty || ndCauHoiController.text.isEmpty) {
                      _showErrorDialog(
                          "Lỗi", "Vui lòng chọn và nhập đầy đủ thông tin.");
                    } else if (selectedMonHoc.isEmpty) {
                      _showErrorDialog("Lỗi", "Vui lòng chọn Tên môn học.");
                    } else if (selectedChuDe.isEmpty) {
                      _showErrorDialog("Lỗi", "Vui lòng chọn Tên chủ đề.");
                    } else if (selectedLoaiCauHoi.isEmpty) {
                      _showErrorDialog("Lỗi", "Vui lòng chọn loại câu hỏi.");
                    } else if (ndCauHoiController.text.isEmpty) {
                      _showErrorDialog("Lỗi", "Vui lòng nhập nội dung câu hỏi.");
                    } else {
                      String? imageUrl;
                      String? idImage;
                      if (selectedImage != null) {
                        imageUrl = await firebaseService.uploadImage(selectedImage!);
                        print("Ảnh test: $imageUrl");

                        idImage = await firebaseService.insertImage(imageUrl);
                      }

                      await DatabaseService.insertQuestion(
                        ndCauHoiController.text,
                        selectedImage != null ? imageUrl! : '',
                        selectedLoaiCauHoi,
                        dapAnAController.text,
                        dapAnBController.text,
                        dapAnCController.text,
                        dapAnDController.text,
                        dapAnEController.text,
                        dapAnFController.text,
                        dapAnGController.text,
                        dapAnHController.text,
                        selectedDapAnDung != null ? [selectedDapAnDung!] : [],
                        selectedMonHoc,
                        selectedChuDe,
                        idImage ?? '',
                      );

                      setState(() {
                        selectedQuestionsInExam.add(ndCauHoiController.text);

                        ndCauHoiController.clear();
                        dapAnAController.clear();
                        dapAnBController.clear();
                        dapAnCController.clear();
                        dapAnDController.clear();
                        dapAnEController.clear();
                        dapAnFController.clear();
                        dapAnGController.clear();
                        dapAnHController.clear();
                        selectedImage = null;
                        selectedDapAnDung = null;
                        dapAnDungList.clear();
                        danhSachControllers.clear();
                        soLuongDapAnDaThem = 2;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Thêm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {
    });
  }

  _appBar() {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      title: const Text(
        "Tạo Đề Thi",
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

  void _showRandomQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController quantityController = TextEditingController();
        return AlertDialog(
          title: const Text("Nhập số lượng câu hỏi"),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Số lượng câu hỏi",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity > 0) {
                  List<String> cauHoiList = await DatabaseService.getNoiDungCauHoiList(selectedChuDe);

                  // Lọc ra các câu hỏi đã có trong selectedQuestionsInExam
                  List<String> filteredCauHoiList = cauHoiList.where((cauHoi) => !selectedQuestionsInExam.contains(cauHoi)).toList();

                  // Nếu số lượng yêu cầu lớn hơn số lượng câu hỏi sau khi lọc, giới hạn lại số lượng
                  if (quantity > filteredCauHoiList.length) {
                    quantity = filteredCauHoiList.length;
                  }

                  // Shuffle và chọn ngẫu nhiên các câu hỏi
                  filteredCauHoiList.shuffle(Random());
                  setState(() {
                    selectedQuestionsInExam.addAll(filteredCauHoiList.take(quantity));
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(fontSize: 14.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Đóng"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
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
              Navigator.pop(context, true);
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
              // Navigator.pop(context, false); // Trả về giá trị false khi chọn "Không"
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamManagement()));
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

  Widget _buildAnswerOption(String option, TextEditingController controller, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Xóa tất cả các đáp án đã được chọn trước đó khỏi dapAnDungMap
          dapAnDungMap.clear();
          // Thêm đáp án mới được chọn vào dapAnDungMap
          dapAnDungMap[option] = controller;
          // Cập nhật lại danh sách các đáp án đúng
          selectedDapAnDung = toJson(dapAnDungMap);
          print(selectedDapAnDung);
        });
      },
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Đáp Án $option",
                hintText: "Nhập đáp án $option",
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
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dapAnDungMap.containsKey(option)
                  ? Colors.green
                  : Colors.red.withOpacity(0.7),
            ),
            alignment: Alignment.center,
            child: Text(
              option,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCheckBox(String option, TextEditingController controller, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Nếu đáp án đã được chọn, hãy loại bỏ nó khỏi danh sách
          if (dapAnDungMap.containsKey(option)) {
            dapAnDungMap.remove(option);
          } else {
            // Nếu đáp án chưa được chọn, hãy thêm nó vào danh sách
            dapAnDungMap[option] = controller;
          }
          dapAnDungList.sort();
          // Cập nhật lại danh sách các đáp án đúng
          selectedDapAnDung = toJson(dapAnDungMap);
          print(selectedDapAnDung);
        });
      },
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Đáp Án $option",
                hintText: "Nhập đáp án $option",
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
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
              color: dapAnDungMap.containsKey(option)
                  ? Colors.green
                  : Colors.red.withOpacity(0.7),
            ),
            alignment: Alignment.center,
            child: Text(
              option,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String toJson(Map<String, TextEditingController> dapAnDungMap) {
    Map<String, dynamic> jsonMap = {};
    dapAnDungMap.forEach((option, controller) {
      String content = controller.text;
      jsonMap['dapAn$option'] = content;
    });
    return jsonEncode(jsonMap);
  }

}
