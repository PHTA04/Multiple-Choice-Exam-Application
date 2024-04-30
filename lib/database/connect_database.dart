import 'package:mysql1/mysql1.dart';

class MySqlDatabase {
  late MySqlConnection _connection;

  Future<void> connect() async {
    final settings = ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'thitracnghiem',
    );

    try {
      _connection = await MySqlConnection.connect(settings);
      print('Kết nối tới MySQL thành công');
    } catch (e) {
      print('Lỗi kết nối tới MySQL: $e');
    }
  }

  Future<String> insertSubject(String maMonHoc, String tenMonHoc) async {
    try {
      final result = await _connection.query(
        'SELECT COUNT(*) as count FROM MonHoc WHERE maMonHoc = ?',
        [maMonHoc],
      );

      final count = result.first['count'] as int;
      if (count > 0) {
        return 'Mã môn học đã tồn tại.';
      }

      await _connection.query(
        'INSERT INTO MonHoc (maMonHoc, tenMonHoc) VALUES (?, ?)',
        [maMonHoc, tenMonHoc],
      );
      return 'Môn học đã được thêm thành công.';
    } catch (error) {
      return 'Môn học được thêm thất bại do: $error';
    }
  }

  Future<List<String>> getTenMonHocList() async {
    try {
      var results = await _connection.query('SELECT tenMonHoc FROM MonHoc');
      List<String> tenMonHocList = [];
      for (var row in results) {
        tenMonHocList.add(row['tenMonHoc']);
      }

      print(tenMonHocList);
      return tenMonHocList;
    } catch (error, stackTrace) {
      print('Lỗi khi lấy danh sách tên môn học: $error');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMonHoc() async {
    try {
      var results = await _connection.query('SELECT maMonHoc, tenMonHoc FROM MonHoc');
      return results.map((row) => row.fields).toList();
    } catch (error, stackTrace) {
      print('Lỗi khi lấy danh sách môn học: $error');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<String> updateSubject(String maMonHoc, String tenMonHoc) async {
    try {
      final result = await _connection.query(
        'SELECT COUNT(*) as count FROM MonHoc WHERE maMonHoc = ?',
        [maMonHoc],
      );

      final count = result.first['count'] as int;
      if (count == 0) {
        return 'Mã môn học không tồn tại.';
      }

      await _connection.query(
        'UPDATE MonHoc SET maMonHoc = ?, tenMonHoc = ? WHERE maMonHoc = ?',
        [maMonHoc, tenMonHoc, maMonHoc],
      );
      return 'Cập nhật môn học thành công.';
    } catch (error) {
      return 'Cập nhật môn học thất bại do: $error';
    }
  }

  Future<String> deleteSubject(String maMonHoc) async {
    try {
      final result = await _connection.query(
        'SELECT COUNT(*) as count FROM MonHoc WHERE maMonHoc = ?',
        [maMonHoc],
      );

      final count = result.first['count'] as int;
      if (count == 0) {
        return 'Mã môn học không tồn tại.';
      }

      await _connection.query(
        'DELETE FROM MonHoc WHERE maMonHoc = ?',
        [maMonHoc],
      );
      return 'Môn học đã được xóa thành công.';
    } catch (error) {
      return 'Xóa môn học thất bại do: $error';
    }
  }

  Future<String> insertTopic(String tenChuDe, String tenMonHoc) async {
    try {
      final result = await _connection.query(
        'SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?',
        [tenMonHoc],
      );
      final maMonHoc = result.first['maMonHoc'];

      await _connection.query(
        'INSERT INTO ChuDe (tenChuDe, maMonHoc) VALUES (?, ?)',
        [tenChuDe, maMonHoc],
      );

      return 'Chủ đề đã được thêm thành công.';
    } catch (error) {

      return 'Chủ đề được thêm thất bại do: $error';
    }
  }

  Future<List<Map<String, dynamic>>> getChuDe() async {
    try {
      var results = await _connection.query('SELECT ChuDe.maChuDe, ChuDe.tenChuDe, MonHoc.tenMonHoc FROM ChuDe INNER JOIN MonHoc ON ChuDe.maMonHoc = MonHoc.maMonHoc');
      print(results);
      return results.map((row) => row.fields).toList();
    } catch (error, stackTrace) {
      print('Lỗi khi lấy danh sách môn học: $error');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<String> updateTopic(String maChuDe, String tenChuDe, String tenMonHoc) async {
    try {
      final result = await _connection.query(
        'SELECT COUNT(*) as count FROM ChuDe WHERE maChuDe = ?',
        [maChuDe],
      );

      final count = result.first['count'] as int;
      if (count == 0) {
        return 'Mã chủ đề không tồn tại.';
      }

      final monHocResult = await _connection.query(
        'SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?',
        [tenMonHoc],
      );
      final maMonHoc = monHocResult.first['maMonHoc'];

      await _connection.query(
        'UPDATE ChuDe SET tenChuDe = ?, maMonHoc = ? WHERE maChuDe = ?',
        [tenChuDe, maMonHoc, maChuDe],
      );
      return 'Cập nhật chủ đề thành công.';
    } catch (error) {
      return 'Cập nhật chủ đề thất bại do: $error';
    }
  }

  Future<String> deleteTopic(String maChuDe) async {
    try {
      final result = await _connection.query(
        'SELECT COUNT(*) as count FROM ChuDe WHERE maChuDe = ?',
        [maChuDe],
      );

      final count = result.first['count'] as int;
      if (count == 0) {
        return 'Mã chủ đề không tồn tại.';
      }

      await _connection.query(
        'DELETE FROM ChuDe WHERE maChuDe = ?',
        [maChuDe],
      );
      return 'Chủ đề đã được xóa thành công.';
    } catch (error) {
      return 'Xóa chủ đề thất bại do: $error';
    }
  }

  Future<void> close() async {
    await _connection.close();
  }
}
