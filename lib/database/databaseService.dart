import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  static const String ipName = '192.168.1.2';
  static const String port = '2612';
  static const String baseUrl = 'http://$ipName:$port';

  static Future<String> insertSubject(String maMonHoc, String tenMonHoc) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insertSubject'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'maMonHoc': maMonHoc,
        'tenMonHoc': tenMonHoc,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to insert subject');
    }
  }

  static Future<List<Map<String, dynamic>>> getSubject() async {
    final response = await http.get(Uri.parse('$baseUrl/getMonHoc'));
    if (response.statusCode == 200) {
      Iterable decodedBody = jsonDecode(response.body);
      List<Map<String, dynamic>> monHocList = List<Map<String, dynamic>>.from(decodedBody);
      return monHocList;
    } else {
      throw Exception('Failed to load list of subjects');
    }
  }

  static Future<List<String>> getTenMonHocList() async {
    final response = await http.get(Uri.parse('$baseUrl/getTenMonHocList'));
    if (response.statusCode == 200) {
      Iterable decodedBody = jsonDecode(response.body);
      List<String> tenMonHocList = List<String>.from(decodedBody);
      return tenMonHocList;
    } else {
      throw Exception('Failed to load list of subjects');
    }
  }

  static Future<String> updateSubject(String maMonHoc, String tenMonHoc) async {
    final response = await http.post(
      Uri.parse('$baseUrl/updateSubject'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'maMonHoc': maMonHoc,
        'tenMonHoc': tenMonHoc,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update subject');
    }
  }

  static Future<String> deleteSubject(String maMonHoc) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deleteSubject'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'maMonHoc': maMonHoc,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete subject');
    }
  }

  static Future<String> insertTopic(String tenChuDe, String tenMonHoc) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insertTopic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tenChuDe': tenChuDe,
        'tenMonHoc': tenMonHoc,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to insert topic');
    }
  }

  static Future<List<Map<String, dynamic>>> getTopic() async {
    final response = await http.get(Uri.parse('$baseUrl/getTopic'));
    if (response.statusCode == 200) {
      Iterable decodedBody = jsonDecode(response.body);
      List<Map<String, dynamic>> chuDeList = List<Map<String, dynamic>>.from(decodedBody);
      return chuDeList;
    } else {
      throw Exception('Failed to load list of topics');
    }
  }

  static Future<List<String>> getTenChuDeList(String tenMonHoc) async {
    // Kiểm tra nếu tenMonHoc là null hoặc chuỗi trống
    if (tenMonHoc == null || tenMonHoc.isEmpty) {
      // Trả về danh sách rỗng
      return [];
    }

    final response = await http.post(
      Uri.parse('$baseUrl/getTenChuDeList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tenMonHoc': tenMonHoc,
      }),
    );

    if (response.statusCode == 200) {
      // Chuyển đổi dữ liệu từ dạng JSON sang List<String>
      var decodedBody = jsonDecode(response.body);
      if (decodedBody is List) {
        // Kiểm tra xem danh sách chủ đề có rỗng không
        if (decodedBody.isEmpty) {
          // Trả về danh sách rỗng
          return [];
        } else {
          List<String> tenChuDeList = List<String>.from(decodedBody);
          return tenChuDeList;
        }
      } else if (decodedBody == null) {
        // Trường hợp nếu trả về thông báo không tìm thấy chủ đề
        return [];
      } else {
        // Nếu không phải List, có thể xảy ra lỗi hoặc dữ liệu không hợp lệ
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load list of topics');
    }
  }

  static Future<String> updateTopic(String maChuDe, String tenChuDe, String tenMonHoc) async {
    final response = await http.post(
      Uri.parse('$baseUrl/updateTopic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'maChuDe': maChuDe,
        'tenChuDe': tenChuDe,
        'tenMonHoc': tenMonHoc,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update topic');
    }
  }

  static Future<String> deleteTopic(String maChuDe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deleteTopic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'maChuDe': maChuDe,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete topic');
    }
  }

  static Future<String> insertQuestion(
      String ndCauHoi,
      String imageCauHoi,
      String loaiCauHoi,
      String dapAnA,
      String dapAnB,
      String dapAnC,
      String dapAnD,
      String dapAnE,
      String dapAnF,
      String dapAnG,
      String dapAnH,
      List<String> dapAnDung,
      String tenMonHoc,
      String tenChuDe,
      ) async {
    // Lấy danh sách chủ đề từ tên môn học
    List<String> tenChuDeList = await getTenChuDeList(tenMonHoc);

    // Kiểm tra xem chủ đề có tồn tại không
    if (!tenChuDeList.contains(tenChuDe)) {
      throw Exception('Tên chủ đề không tồn tại trong môn học này');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/insertQuestion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ndCauHoi': ndCauHoi,
        'imageCauHoi': imageCauHoi,
        'loaiCauHoi': loaiCauHoi,
        'dapAnA': dapAnA,
        'dapAnB': dapAnB,
        'dapAnC': dapAnC,
        'dapAnD': dapAnD,
        'dapAnE': dapAnE,
        'dapAnF': dapAnF,
        'dapAnG': dapAnG,
        'dapAnH': dapAnH,
        'dapAnDung': dapAnDung,
        'tenMonHoc': tenMonHoc,
        'tenChuDe': tenChuDe,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to insert question');
    }
  }


}