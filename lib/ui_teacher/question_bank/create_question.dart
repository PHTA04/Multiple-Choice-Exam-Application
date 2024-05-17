import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/database/firebaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/create_topic.dart';
import 'package:multiple_choice_exam/ui_teacher/question_bank/question_bank.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({super.key});

  @override
  State<CreateQuestion> createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  List<String> loaiCauHoiList = [
    'Câu Hỏi 1 Đáp Án Đúng',
    'Câu Hỏi Nhiều Đáp Án Đúng',
    'Câu Hỏi Đúng Sai'
  ];
  String selectedLoaiCauHoi = '';

  List<String> tenMonHocList = []; // Danh sách tên môn học
  String selectedMonHoc = ''; // Môn học được chọn

  List<String> tenChuDeList = [];
  String selectedChuDe = '';

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
                                selectedChuDe = '';
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

                  _buildAnswerOption('A', dapAnAController),
                  const SizedBox(height: 20),
                  _buildAnswerOption('B', dapAnBController),
                  const SizedBox(height: 20),

                  Column(
                    children: danhSachControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      return Column(
                        children: [
                          _buildAnswerOption(String.fromCharCode(65 + index + 2), controller), // Bắt đầu từ C
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
                  _buildAnswerCheckBox('A', dapAnAController),
                  const SizedBox(height: 20),
                  _buildAnswerCheckBox('B', dapAnBController),
                  const SizedBox(height: 20),
                  _buildAnswerCheckBox('C', dapAnCController),
                  const SizedBox(height: 20),

                  Column(
                    children: danhSachControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      return Column(
                        children: [
                          _buildAnswerCheckBox(String.fromCharCode(65 + index + 3), controller), // Bắt đầu từ C
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
                    _buildAnswerOption('A', dapAnAController),
                    const SizedBox(height: 20),
                    _buildAnswerOption('B', dapAnBController),
                    const SizedBox(height: 20),
                  ],

                ElevatedButton(
                    onPressed: () async {
                      if(selectedMonHoc.isEmpty && selectedChuDe.isEmpty && selectedLoaiCauHoi.isEmpty && ndCauHoiController.text.isEmpty){
                        _showErrorDialog("Lỗi", "Vui lòng chọn và nhập đầy đủ thông tin.");
                      } else if(selectedMonHoc.isEmpty){
                        _showErrorDialog("Lỗi", "Vui lòng chọn Tên môn học.");
                      } else if(selectedChuDe.isEmpty){
                        _showErrorDialog("Lỗi", "Vui lòng chọn Tên chủ đề.");
                      } else if(selectedLoaiCauHoi.isEmpty){
                        _showErrorDialog("Lỗi", "Vui lòng chọn loại câu hỏi.");
                      } else if(ndCauHoiController.text.isEmpty){
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
                        _showSuccessDialog("Câu hỏi đã được thêm thành công, bạn có muốn thêm câu hỏi khác không ?");

                        setState(() {
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
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Thêm Câu Hỏi")
                ),
              ],
            ),
          ),
        ));
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

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {
    });
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

  Widget _buildAnswerOption(String option, TextEditingController controller) {
    print("Controller name: ${controller.runtimeType}");
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Đáp Án $option",
              hintText: "Nhập đáp án $option",
              labelStyle: TextStyle(color: Theme.of(context).hintColor),
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
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
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDapAnDung = option; // Cập nhật đáp án đúng được chọn
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedDapAnDung == option
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
        ),
      ],
    );
  }

  Widget _buildAnswerCheckBox(String option, TextEditingController controller) {
    return Row(
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
        GestureDetector(
          onTap: () {
            setState(() {
              // Nếu đáp án đã được chọn, hãy loại bỏ nó khỏi danh sách
              if (dapAnDungList.contains(option)) {
                dapAnDungList.remove(option);
              } else {
                // Nếu đáp án chưa được chọn, hãy thêm nó vào danh sách
                dapAnDungList.add(option);
              }
              // Cập nhật lại danh sách các đáp án đúng
              selectedDapAnDung = dapAnDungList.isNotEmpty ? dapAnDungList.join(",") : null;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
              color: dapAnDungList.contains(option) // Kiểm tra xem đáp án có được chọn không
                  ? Colors.green // Nếu có, sử dụng màu xanh
                  : Colors.red.withOpacity(0.7), // Nếu không, sử dụng màu đỏ
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
        ),
      ],
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionBank()));
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
