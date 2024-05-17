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

  List<String> tenDeThiList = [];
  String selectedDeThi = '';

  TextEditingController tenBaiThiController = TextEditingController();
  TextEditingController thoiGianLamBaiController = TextEditingController();
  TextEditingController ngayBatDauController = MaskedTextController(mask: '0000/00/00');
  TextEditingController ngayKetThucController = MaskedTextController(mask: '0000/00/00');
  TextEditingController gioBatDauController = MaskedTextController(mask: '00:00');
  TextEditingController gioKetThucController = MaskedTextController(mask: '00:00');
  TextEditingController soLanLamBaiController = TextEditingController();

  String selectedOption = '';
  bool allowReview = false;


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
                          onChanged: (String? selected) {
                            setState(() {
                              selectedDeThi = selected!;
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
                controller: tenBaiThiController,
                decoration: InputDecoration(
                  labelText: "Tên bài thi",
                  hintText: "Nhập tên bài thi",
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: ngayBatDauController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: "Ngày bắt đầu",
                          hintText: "YYYY-MM-DD",
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
                                  ngayBatDauController.text = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                }
                              });
                            },
                            icon: const Icon(Icons.date_range_outlined),
                          ),
                        ),
                      ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                      child: TextFormField(
                        controller: ngayKetThucController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: "Ngày kết thúc",
                          hintText: "YYYY-MM-DD",
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
                                  ngayKetThucController.text = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                }
                              });
                            },
                            icon: const Icon(Icons.date_range_outlined),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: gioBatDauController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Giờ bắt đầu",
                        hintText: "HH:mm",
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
                            // Hiển thị chọn giờ khi nhấn vào icon
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectedTime) {
                              if (selectedTime != null) {
                                gioBatDauController.text = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                              }
                            });
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: gioKetThucController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Giờ kết thúc",
                        hintText: "HH:mm",
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
                            // Hiển thị chọn giờ khi nhấn vào icon
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectedTime) {
                              if (selectedTime != null) {
                                gioKetThucController.text = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                              }
                            });
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                ],
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

              Row(
                children: [
                  const Text(
                    'Cho phép xem lại bài thi: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Có';
                            allowReview = true; // Cập nhật giá trị allowReview thành true khi chọn 'Có'
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: 'Có',
                              groupValue: selectedOption,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedOption = value!;
                                  allowReview = value == 'Có'; // Cập nhật giá trị allowReview dựa trên giá trị được chọn
                                });
                              },
                            ),
                            Text(
                              'Có',
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedOption == 'Có' ? Colors.blue : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Không';
                            allowReview = false; // Cập nhật giá trị allowReview thành false khi chọn 'Không'
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: 'Không',
                              groupValue: selectedOption,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedOption = value!;
                                  allowReview = value == 'Có'; // Cập nhật giá trị allowReview dựa trên giá trị được chọn
                                });
                              },
                            ),
                            Text(
                              'Không',
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedOption == 'Không' ? Colors.blue : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {

                  if(selectedMonHoc.isEmpty && selectedDeThi.isEmpty && tenBaiThiController.text.isEmpty && thoiGianLamBaiController.text.isEmpty && ngayBatDauController.text.isEmpty && ngayKetThucController.text.isEmpty && gioBatDauController.text.isEmpty && gioKetThucController.text.isEmpty && soLanLamBaiController.text.isEmpty && selectedOption.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn và nhập đầy đủ thông tin.");
                  } else if(selectedMonHoc.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn Tên môn học.");
                  } else if(selectedDeThi.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn Tên đề thi.");
                  } else if(tenBaiThiController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Tên bài thi.");
                  } else if(thoiGianLamBaiController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Thời gian làm bài thi.");
                  } else if(ngayBatDauController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Ngày bắt đầu.");
                  } else if(ngayKetThucController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Ngày kết thúc.");
                  } else if(gioBatDauController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Giờ bắt đầu.");
                  } else if(gioKetThucController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Giờ kết thúc.");
                  } else if(soLanLamBaiController.text.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng nhập Số lần làm bài thi.");
                  } else if(selectedOption.isEmpty){
                    _showErrorDialog("Lỗi", "Vui lòng chọn Cho phép xem lại bài thi không.");
                  } else {
                    String gioBatDau = '${gioBatDauController.text}:00';
                    String gioKetThuc = '${gioKetThucController.text}:00';

                    await DatabaseService.insertTest(
                      selectedDeThi,
                      tenBaiThiController.text,
                      int.parse(thoiGianLamBaiController.text),
                      ngayBatDauController.text,
                      ngayKetThucController.text,
                      gioBatDau,
                      gioKetThuc,
                      int.parse(soLanLamBaiController.text),
                      allowReview,
                    );

                    _showSuccessDialog("Bài thi đã được thêm thành công, bạn có muốn thêm bài thi khác không ?");

                    setState(() {
                      tenBaiThiController.clear();
                      thoiGianLamBaiController.clear();
                      ngayBatDauController.clear();
                      ngayKetThucController.clear();
                      gioBatDauController.clear();
                      gioKetThucController.clear();
                      soLanLamBaiController.clear();
                      selectedOption.isEmpty;
                    });
                  }

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTest()));
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
