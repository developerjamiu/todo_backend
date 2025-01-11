import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_backend/repositories/mongo_db_todo_repository.dart';
import 'package:todo_backend/repositories/todo_repository.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final connectionString = Platform.environment['TODO_MONGO_DB_URI'] ?? '';

    final db = await Db.create(connectionString);

    if (!db.isConnected) await db.open();

    final response = await handler
        .use(
          provider<TodoRepository>((context) => MongoDBTodoRepository(db: db)),
        )
        .call(context);

    await db.close();

    return response;
  };
}
