/// AppTodo class. It contains the title, description, and isCompleted fields.
class Todo {
  /// AppTodo constructor
  const Todo({
    required this.name,
    this.description,
    this.isCompleted = false,
  });

  /// fromMap factory
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  /// name
  final String name;

  /// description
  final String? description;

  /// isCompleted
  final bool isCompleted;

  /// copyWith method
  Todo copyWith({
    String? name,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// toMap method
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      if (description != null) 'description': description,
      'isCompleted': isCompleted,
    };
  }
}
