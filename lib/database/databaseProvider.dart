import 'package:flutter/material.dart';
import 'package:multiple_choice_exam/database/connect_database.dart';

class DatabaseProvider extends ChangeNotifier {
  MySqlDatabase? _database;

  MySqlDatabase get database {
    if (_database == null) {
      throw Exception("Database has not been initialized.");
    }
    return _database!;
  }

  Future<void> connectToDatabase() async {
    _database = MySqlDatabase();
    await _database!.connect();
    notifyListeners();
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      notifyListeners();
    }
  }
}