/// An abstract class that defines the contract for a Todo repository.
///
/// This repository is responsible for managing the data operations related
/// to Todo items, such as fetching, adding, updating, and deleting todos.
/// Implementations of this class should provide the actual data handling
/// logic, whether it be from a local database, a remote server, or any other
/// data source.
abstract class TodoRepository {
  /// Retrieves a list of todos.
  ///
  /// Returns a [Future] that completes with a list of maps, where each map
  /// represents a todo item with its properties as key-value pairs.
  Future<List<Map<String, dynamic>>> getTodos();

  /// Adds a new todo item to the repository.
  ///
  /// Takes a [body] parameter which is a map containing the details of the todo
  /// item.
  ///
  /// Returns a [Future] that completes with a map containing the details of the
  /// added todo item.
  Future<Map<String, dynamic>> addTodo(Map<String, dynamic> body);

  /// Retrieves a todo item by its unique identifier.
  ///
  /// Takes a [String] parameter [id] which represents the unique identifier
  /// of the todo item.
  ///
  /// Returns a [Future] that resolves to a [Map<String, dynamic>] containing
  /// the details of the todo item.
  Future<Map<String, dynamic>> getTodoById(String id);

  /// Updates a todo item with the given [id] using the provided [body].
  ///
  /// The [id] parameter specifies the unique identifier of the todo item to be
  /// updated.
  /// The [body] parameter is a map containing the fields and values to update
  /// in the todo item.
  ///
  /// This method returns a [Future] that completes when the update operation is
  /// finished.
  Future<void> updateTodo(String id, Map<String, dynamic> body);

  /// Deletes a todo item by its unique identifier.
  ///
  /// This method removes the todo item associated with the given [id]
  /// from the repository.
  Future<void> deleteTodo(String id);
}
