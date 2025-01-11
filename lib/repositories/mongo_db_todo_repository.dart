import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_backend/models/app_exception.dart';
import 'package:todo_backend/models/todo.dart';
import 'package:todo_backend/repositories/todo_repository.dart';

/// The name of the collection used to store todo items in the database.
const collectionName = 'todos';

/// A repository class that handles the data operations for Todo items.
///
/// This class provides methods to perform CRUD (Create, Read, Update, Delete)
/// operations on Todo items. It acts as an intermediary between the data source
/// (e.g., a database or an API) and the rest of the application, ensuring that
/// data is fetched, stored, and manipulated correctly.
///
/// Example usage:
///
/// ```dart
/// final todoRepository = TodoRepository();
/// final todos = await todoRepository.getAllTodos();
/// ```
class MongoDBTodoRepository implements TodoRepository {
  /// Creates an instance of [MongoDBTodoRepository] with the given [Db]
  /// instance.
  ///
  /// The [db] parameter is required and is used to initialize the private
  /// database field [_db].
  ///
  /// Example usage:
  /// ```dart
  /// final db = Db('mongodb://localhost:27017/todo_db');
  /// final repository = TodoRepository(db: db);
  /// ```
  MongoDBTodoRepository({required Db db}) : _db = db;

  final Db _db;

  @override
  Future<List<Map<String, dynamic>>> getTodos() async {
    return _db.collection(collectionName).find().toList();
  }

  @override
  Future<Map<String, dynamic>> addTodo(Map<String, dynamic> body) async {
    final name = body['name'] as String?;
    final description = body['description'] as String?;

    if (name == null || name.isEmpty) {
      throw AppException('The "name" field is required and cannot be empty.');
    }

    final newTodo = Todo(
      name: name,
      description: description,
    );

    final result = await _db.collection(collectionName).insertOne(
          newTodo.toMap(),
        );

    final document = result.document;

    if (document == null) {
      throw AppException('There was an error creating the todo.');
    }

    return document;
  }

  @override
  Future<Map<String, dynamic>> getTodoById(String id) async {
    try {
      final todo = await _db.collection(collectionName).findOne(
            where.eq('_id', ObjectId.fromHexString(id)),
          );

      if (todo == null) throw AppException('Todo not found');
      return todo;
    } catch (e) {
      throw AppException('Todo not found');
    }
  }

  @override
  Future<void> updateTodo(String id, Map<String, dynamic> body) async {
    try {
      final name = body['name'] as String?;
      final description = body['description'] as String?;
      final isCompleted = body['isCompleted'] as bool?;

      final modifier = ModifierBuilder();
      if (name != null) modifier.set('name', name);
      if (description != null) modifier.set('description', description);
      if (isCompleted != null) modifier.set('isCompleted', isCompleted);

      await _db.collection(collectionName).update(
            where.eq('_id', ObjectId.fromHexString(id)),
            modifier,
          );
    } catch (e) {
      throw AppException('There was an error updating the todo.');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _db
        .collection(collectionName)
        .deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
  }
}
