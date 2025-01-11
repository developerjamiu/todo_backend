import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/models/app_exception.dart';
import 'package:todo_backend/repositories/todo_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.get => _getTodoById(context, id),
    HttpMethod.put => _updateTodo(context, id),
    HttpMethod.delete => _deleteTodo(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getTodoById(RequestContext context, String id) async {
  try {
    final todo = await context.read<TodoRepository>().getTodoById(id);

    return Response.json(
      body: todo,
    );
  } on AppException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'errorMessage': e.message},
    );
  }
}

Future<Response> _updateTodo(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;

  await context.read<TodoRepository>().updateTodo(id, body);

  return Response(statusCode: HttpStatus.noContent);
}

Future<Response> _deleteTodo(RequestContext context, String id) async {
  await context.read<TodoRepository>().deleteTodo(id);

  return Response(statusCode: HttpStatus.noContent);
}
