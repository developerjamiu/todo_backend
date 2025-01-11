import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_backend/repositories/in_memory_todo_repository.dart';
import 'package:todo_backend/repositories/mongo_db_todo_repository.dart';
import 'package:todo_backend/repositories/todo_repository.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final connectionString = Platform.environment['TODO_MONGO_DB_URI'] ?? '';

    final TodoRepository repository;
    Db? db;

    if (connectionString.isNotEmpty) {
      db = await Db.create(connectionString);
      if (!db.isConnected) await db.open();
      repository = MongoDBTodoRepository(db: db);
    } else {
      repository = InMemoryTodoRepository();
    }

    try {
      final response = await handler
          .use(provider<TodoRepository>((context) => repository))
          .call(context);

      return response;
    } finally {
      if (db != null && db.isConnected) await db.close();
    }
  };
}
