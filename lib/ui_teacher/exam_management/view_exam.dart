import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_choice_exam/database/databaseService.dart';
import 'package:multiple_choice_exam/ui_teacher/exam_management/create_exam.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ViewExam extends StatefulWidget {
  const ViewExam({super.key});

  @override
  State<ViewExam> createState() => _ViewExamState();
}

class _ViewExamState extends State<ViewExam> {

  List<String> tenMonHocList = []; // Danh sách tên môn học
  String selectedMonHoc = ''; // Môn học được chọn

  List<String> tenDeThiList = [];
  String selectedDeThi = '';

  List<Map<String, dynamic>> cauHoiList = [];
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

                            List<Map<String, dynamic>> fetchedCauHoiList = await DatabaseService.getDanhSachCauHoi(selectedDeThi);

                            setState(() {
                              cauHoiList = fetchedCauHoiList;
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

              ...cauHoiList.map((question) => buildQuestionCard(question)),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateAndSavePdf,
                child: const Text('Xuất PDF'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  List<String> convertDapAnDung(dynamic dapAnDung) {
    if (dapAnDung is Map<String, dynamic>) {
      return dapAnDung.values.map((e) => e.toString()).toList();
    } else if (dapAnDung is List<String>) {
      return dapAnDung;
    } else {
      return [];
    }
  }

  Widget buildQuestionCard(Map<String, dynamic> question) {
    List<String> correctAnswers = convertDapAnDung(question['dapAnDung']);
    List<String> options = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Câu hỏi: ${question['ndCauHoi']} ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: '(${question['loaiCauHoi']})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                if (question['imageCauHoi'] != null && question['imageCauHoi'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.network(question['imageCauHoi']),
                  ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    for (String option in options)
                      if (question['dapAn$option'] != null && question['dapAn$option'].isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: correctAnswers.contains(question['dapAn$option'])
                                ? Colors.greenAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            question['dapAn$option'],
                            style: TextStyle(
                              fontSize: 16,
                              color: correctAnswers.contains(question['dapAn$option'])
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Đáp án đúng: ${correctAnswers.join(', ')}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateAndSavePdf() async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final fontBold = await rootBundle.load("assets/fonts/NotoSans-Bold.ttf");
    final ttfBold = pw.Font.ttf(fontBold);

    for (var question in cauHoiList) {
      List<String> correctAnswers = convertDapAnDung(question['dapAnDung']);
      List<String> options = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

      Uint8List? imageBytes;
      if (question['imageCauHoi'] != null && question['imageCauHoi'].isNotEmpty) {
        imageBytes = await _loadNetworkImage(question['imageCauHoi']);
      }

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Câu hỏi: ${question['ndCauHoi']} (${question['loaiCauHoi']})',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, font: ttfBold),
                ),
                pw.SizedBox(height: 10),
                if (imageBytes != null)
                  pw.Image(pw.MemoryImage(imageBytes)),
                pw.SizedBox(height: 10),
                ...options.map((option) {
                  if (question['dapAn$option'] != null && question['dapAn$option'].isNotEmpty) {
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 10),
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: correctAnswers.contains(question['dapAn$option']) ? PdfColors.greenAccent : PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(10),
                        border: pw.Border.all(color: PdfColors.black, width: 0.5),
                      ),
                      child: pw.Text(
                        question['dapAn$option'],
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: correctAnswers.contains(question['dapAn$option']) ? PdfColors.white : PdfColors.black,
                          font: ttf,
                        ),
                      ),
                    );
                  }
                  return pw.SizedBox.shrink();
                }).toList(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Đáp án đúng: ${correctAnswers.join(', ')}',
                  style: pw.TextStyle(fontSize: 16, color: PdfColors.green, font: ttf),
                ),
              ],
            );
          },
        ),
      );
    }

    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/exam.pdf');
    await file.writeAsBytes(await pdf.save());

    final filePath = file.path; // Save the file path
    print(filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã lưu file PDF thành công tại $filePath'),
      ),
    );

    OpenFile.open(filePath);
  }

  Future<Uint8List> _loadNetworkImage(String url) async {
    final response = await HttpClient().getUrl(Uri.parse(url));
    final bytes = await consolidateHttpClientResponseBytes(await response.close());
    return bytes;
  }

  _appBar() {
    return AppBar(
      elevation: 10,
      centerTitle: true,
      title: const Text(
        "Xem Đề Thi",
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
