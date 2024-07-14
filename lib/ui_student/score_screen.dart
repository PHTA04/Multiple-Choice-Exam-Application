import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/ui_student/home_sinhvien.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:multiple_choice_exam/ui_student/review_screen.dart';


class ScoreScreen extends StatelessWidget {
  final double score;
  final double correctQuestionCount;
  final int totalQuestions;
  final List<Map<String, dynamic>> cauHoiList;
  final Map<int, List<String>> answers;
  final List<List<String>> dapAnDungList;
  final int choPhepXemLai;

  const ScoreScreen({
    super.key,
    required this.score,
    required this.correctQuestionCount,
    required this.totalQuestions,
    required this.cauHoiList,
    required this.answers,
    required this.dapAnDungList,
    required this.choPhepXemLai,
  });

  @override
  Widget build(BuildContext context) {
    double incorrectQuestionCount = totalQuestions - correctQuestionCount;
    double correctPercentage = (correctQuestionCount / totalQuestions) * 100;
    double incorrectPercentage = (incorrectQuestionCount / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 254),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Điểm bài thi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
                Icons.home,
              size: 32,
              color: Colors.white70,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomeSinhVien(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: _buildCorrectIncorrectPieChart(correctPercentage, incorrectPercentage),
            ),
            const SizedBox(height: 20),
            Text(
              'Bạn đã hoàn thành bài thi: ${correctQuestionCount.toStringAsFixed(2)}/$totalQuestions câu đúng.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Điểm của bạn: ${score.toStringAsFixed(2)}/10 điểm.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if(choPhepXemLai == 1)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        cauHoiList: cauHoiList,
                        answers: answers,
                        dapAnDungList: dapAnDungList,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                child: const Text('Xem lại bài thi'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectIncorrectPieChart(double correctPercentage, double incorrectPercentage) {
    final data = [
      ChartData('Đúng', correctPercentage),
      ChartData('Sai', incorrectPercentage),
    ];

    return SfCircularChart(
      legend: const Legend(isVisible: true),
      series: <DoughnutSeries<ChartData, String>>[
        DoughnutSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.label,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelMapper: (ChartData data, _) => '${data.value.toStringAsFixed(2)}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              // color: Colors.amberAccent,
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          pointColorMapper: (ChartData data, _)
          => data.label == 'Đúng' ? const Color.fromARGB(255, 50, 205, 100) : const Color.fromARGB(255, 255, 120, 106),
        ),
      ],
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}
