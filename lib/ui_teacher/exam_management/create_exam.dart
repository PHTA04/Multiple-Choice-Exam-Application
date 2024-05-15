import 'dart:math';

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

  List<String> noiDungCauHoiList = [];
  Map<String, bool> selectedCauHoi = {};

  TextEditingController tenDeThiController = TextEditingController();

  List<String> selectedQuestionsInExam = [];

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

                      if (selectedChucNang == 'Lấy Danh Sách Các Câu Hỏi Trong Chủ Đề' && selectedChuDe.isNotEmpty) {
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

}