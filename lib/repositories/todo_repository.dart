import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_backend/models/app_exception.dart';
import 'package:todo_backend/models/todo.dart';

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
class TodoRepository {
  /// Creates an instance of [TodoRepository] with the given [Db] instance.
  ///
  /// The [db] parameter is required and is used to initialize the private
  /// database field [_db].
  ///
  /// Example usage:
  /// ```dart
  /// final db = Db('mongodb://localhost:27017/todo_db');
  /// final repository = TodoRepository(db: db);
  /// ```
  TodoRepository({required Db db}) : _db = db;

  final Db _db;

  /// Fetches a list of todos from the repository.
  ///
  /// Returns a [Future] that completes with a list of maps, where each map
  /// represents a todo item with its properties as key-value pairs.
  ///
  /// Example:
  /// ```dart
  /// List<Map<String, dynamic>> todos = await getTodos();
  /// ```
  ///
  /// Throws an exception if there is an error during the fetch operation.
  Future<List<Map<String, dynamic>>> getTodos() async {
    return _db.collection(collectionName).find().toList();
  }

  /// Adds a new todo item to the repository.
  ///
  /// Takes a [Map] containing the details of the todo item as a parameter.
  ///
  /// Returns a [Future] that completes with a [Map] containing the details of
  /// the added todo item.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> newTodo = {
  ///   'title': 'Buy groceries',
  ///   'description': 'Milk, Bread, Eggs',
  /// };
  ///
  /// Map<String, dynamic> addedTodo = await addTodo(newTodo);
  /// ```
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

  /// Retrieves a todo item by its unique identifier.
  ///
  /// This method fetches a todo item from the repository using the provided
  /// [id]. It returns a `Future` that resolves to a `Map<String, dynamic>`
  /// containing the todo item's details.
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

  /// Updates a todo item with the given [id] using the provided [body].
  ///
  /// The [id] parameter specifies the unique identifier of the todo item to be
  /// updated.
  /// The [body] parameter is a map containing the fields and values to be
  /// updated.
  ///
  /// Throws an [Exception] if the update operation fails.
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

  /// Deletes a todo item by its unique identifier.
  ///
  /// This method takes the [id] of the todo item to be deleted and performs
  /// the necessary operations to remove it from the data source.
  ///
  /// [id]: The unique identifier of the todo item to be deleted.
  Future<void> deleteTodo(String id) async {
    await _db
        .collection(collectionName)
        .deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
  }
}
