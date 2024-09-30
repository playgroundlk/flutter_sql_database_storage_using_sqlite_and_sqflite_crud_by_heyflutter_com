import 'package:sqflite/sqflite.dart';

import '../model/todo.dart';
import 'database_service.dart';

class TodoDB {
  final tableName = "todo_list";

  Future<void> createTable(Database database) async {
    await database.execute(
      '''
        CREATE TABLE If NOT EXISTS $tableName(
          "id" INTEGER NOT NULL,
          "title" TEXT NOT NULL,
          "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
          "updated_at" INTEGER,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''',
    );
  }

  Future<int> create({required String title}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''
      INSERT INTO $tableName (title, created_at) VALUES (?,?)
      ''',
      [title, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<Todo>> fetchAll() async {
    final database = await DatabaseService().database;
    final todoList = await database.rawQuery(
      '''
        SELECT * FROM $tableName ORDER BY COALESCE(updated_at, Created_at)
      ''',
    );
    return todoList.map((todo) => Todo.fromSqfliteDatabase(todo)).toList();
  }

  Future<Todo> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todoList = await database.rawQuery(
      '''
        SELECT * FROM $tableName WHERE id = ?
      ''',
      [id],
    );
    return Todo.fromSqfliteDatabase(todoList.first);
  }

  Future<int> update({required int id, String? title}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (title != null) 'title': title,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      '''
        DELETE FROM $tableName WHERE id =?
      ''',
      [id],
    );
  }
}
