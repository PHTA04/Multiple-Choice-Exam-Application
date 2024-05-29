import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cauHoiList;
  final Map<int, List<String>> answers;
  final List<List<String>> dapAnDungList;

  const ReviewScreen({
    super.key,
    required this.cauHoiList,
    required this.answers,
    required this.dapAnDungList,
  });

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isSinglePageMode = true;
  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Xem lại bài thi',
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
            icon: Icon(isSinglePageMode ? Icons.pages_outlined : Icons.list_outlined),
            onPressed: () {
              setState(() {
                isSinglePageMode = !isSinglePageMode;
              });
            },
          ),
        ],
      ),
      body: isSinglePageMode ? buildSinglePageMode() : buildMultiPageMode(),
    );
  }

  Widget buildSinglePageMode() {
    return ListView.builder(
      itemCount: widget.cauHoiList.length,
      itemBuilder: (context, index) {
        return buildQuestionCard(index);
      },
    );
  }

  Widget buildMultiPageMode() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(child: buildQuestionCard(currentQuestionIndex)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestionIndex--;
                    });
                  },
                  child: const Text('Previous'),
                ),
              if (currentQuestionIndex < widget.cauHoiList.length - 1)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuestionCard(int index) {
    List<String> correctAnswers = widget.dapAnDungList[index];
    List<String> userAnswers = widget.answers[index] ?? [];
    bool isMultipleChoice = widget.cauHoiList[index]['loaiCauHoi'] == 'Câu Hỏi Nhiều Đáp Án Đúng';

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
                        text: 'Câu hỏi ${index + 1}: ${widget.cauHoiList[index]['ndCauHoi']} ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: isMultipleChoice
                            ? '(Chọn nhiều đáp án đúng)'
                            : '(Chỉ chọn 1 đáp án đúng)',
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
                if (widget.cauHoiList[index]['imageCauHoi'] != null && widget.cauHoiList[index]['imageCauHoi'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.network(widget.cauHoiList[index]['imageCauHoi']),
                  ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    for (String option in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'])
                      if (widget.cauHoiList[index]['dapAn$option'] != null && widget.cauHoiList[index]['dapAn$option'] != '')
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: correctAnswers.contains(widget.cauHoiList[index]['dapAn$option'])
                                ? Colors.greenAccent
                                : userAnswers.contains(widget.cauHoiList[index]['dapAn$option'])
                                ? Colors.redAccent
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
                            widget.cauHoiList[index]['dapAn$option'],
                            style: TextStyle(
                              fontSize: 16,
                              color: correctAnswers.contains(widget.cauHoiList[index]['dapAn$option']) ||
                                  userAnswers.contains(widget.cauHoiList[index]['dapAn$option'])
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Đáp án của bạn: ${userAnswers.join(', ')}',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
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
}
