import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_data_base/task.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._instance();

  static Database? _db;

  DataBaseHelper._instance();

  String taskTable = "task_Table";
  String colId = "id";
  String colTitle = "title";
  String colDate = "date";
  String colPriority = "priority";
  String colStatus = "status";

  Future<Database?> get db async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute("CREATE TABLE $taskTable("
        "$colId  INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colTitle TEXT,"
        "$colDate TEXT,"
        "$colPriority TEXT,"
        "$colStatus INTEGER)");
  }

  Future<List<Map<String, dynamic>>?> getTaskMapList(
      bool orderByDate, bool filterByStatus) async {
    Database? db = await this.db;
    dynamic query = await db?.query(taskTable);
    final List<Map<String, Object?>>? result = query;

    return result;
  }

  Future<List<Task>> getTaskList(
      {bool orderByDate = false, bool filterByStatus = false}) async {
    final List<Map<String, dynamic>>? taskMapList =
        await getTaskMapList(orderByDate, filterByStatus);
    final List<Task> taskList = [];
    taskMapList?.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });

    return taskList;
  }

  Future<int?> insertTask(Task task) async {
    Database? db = await this.db;
    final int? result = await db?.insert(taskTable, task.toMap());
    return result;
  }
}
