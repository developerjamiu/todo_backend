import 'package:todo_backend/models/app_exception.dart';
import 'package:todo_backend/models/todo.dart';
import 'package:todo_backend/repositories/todo_repository.dart';

final _todos = <Map<String, dynamic>>[];

/// A repository that stores todo items in memory.
///
/// This implementation of [TodoRepository] is useful for testing and
/// development purposes, as it does not require a persistent storage.
///
/// Example usage:
///
/// ```dart
/// final repository = InMemoryTodoRepository();
/// repository.addTodo(TodoItem(id: 1, title: 'Sample Todo'));
/// final todos = repository.getTodos();
/// print(todos); // Output: [TodoItem(id: 1, title: 'Sample Todo')]
/// ```
///
/// Note: This repository does not persist data between application restarts.
class InMemoryTodoRepository implements TodoRepository {
  @override
  Future<List<Map<String, dynamic>>> getTodos() async {
    return _todos;
  }

  @override
  Future<Map<String, dynamic>> addTodo(Map<String, dynamic> body) async {
    final id = DateTime.now().toIso8601String();
    final name = body['name'] as String?;
    final description = body['description'] as String?;

    if (name == null || name.isEmpty) {
      throw AppException('The "name" field is required and cannot be empty.');
    }

    final newTodo = Todo(
      name: name,
      description: description,
    );

    final newTodoMap = {
      'id': id,
      ...newTodo.toMap(),
    };

    _todos.add(newTodoMap);

    return newTodoMap;
  }

  @override
  Future<Map<String, dynamic>> getTodoById(String id) async {
    final todo = _todos.firstWhere(
      (todo) => todo['id'] == id,
      orElse: () => throw AppException('Todo not found'),
    );

    return todo;
  }

  @override
  Future<void> updateTodo(String id, Map<String, dynamic> body) async {
    final name = body['name'] as String?;
    final description = body['description'] as String?;
    final isCompleted = body['isCompleted'] as bool?;

    final index = _todos.indexWhere((todo) => todo['id'] == id);

    if (index == -1) throw AppException('Todo not found');

    final existingTodo = _todos[index];

    final updatedTodo = Todo(
      name: name ?? existingTodo['name'] as String,
      description: description ?? existingTodo['description'] as String?,
      isCompleted: isCompleted ?? existingTodo['isCompleted'] as bool,
    );

    _todos[index] = {
      'id': id,
      ...updatedTodo.toMap(),
    };
  }

  @override
  Future<void> deleteTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo['id'] == id);

    if (index == -1) throw AppException('Todo not found');

    _todos.removeAt(index);
  }
}
