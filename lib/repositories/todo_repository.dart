import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_backend/models/app_exception.dart';
import 'package:todo_backend/models/todo.dart';

/// TodoRepository class
class TodoRepository {
  /// TodoRepository constructor
  TodoRepository({required Db db}) : _db = db;

  final Db _db;

  /// fetchTodos method
  Future<List<Map<String, dynamic>>> getTodos() async {
    return _db.collection('todos').find().toList();
  }

  /// addTodo method
  Future<String> addTodo(Map<String, dynamic> body) async {
    final name = body['name'] as String?;
    final description = body['description'] as String?;

    if (name == null) throw AppException('name is required');

    final newTodo = Todo(
      name: name,
      description: description,
    );

    final result = await _db.collection('todos').insertOne(newTodo.toMap());

    return (result.id as ObjectId).oid;
  }

  /// updateTodo method
  Future<Map<String, dynamic>> getTodo(String id) async {
    final todoMap = await _db.collection('todos').findOne(
          where.eq('_id', ObjectId.fromHexString(id)),
        );

    if (todoMap == null) throw AppException('Todo not found');

    return todoMap;
  }

  /// updateTodo method
  Future<void> updateTodo(String id, Map<String, dynamic> body) async {
    final todoMap = await _db.collection('todos').findOne(
          where.eq('_id', ObjectId.fromHexString(id)),
        );

    final currentName = todoMap?['name'] as String?;
    final currentDescription = todoMap?['description'] as String?;
    final currentIsCompleted = todoMap?['isCompleted'] as bool?;

    final name = body['name'] as String? ?? currentName;
    final description = body['description'] as String? ?? currentDescription;
    final isCompleted = body['isCompleted'] as bool? ?? currentIsCompleted;

    final newTodo = {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isCompleted != null) 'isCompleted': isCompleted,
    };

    await _db.collection('todos').update(
          where.eq('_id', ObjectId.fromHexString(id)),
          newTodo,
        );
  }

  /// deleteTodo method
  Future<void> deleteTodo(String id) async {
    await _db
        .collection('todos')
        .deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
  }
}
