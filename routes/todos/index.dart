import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/models/app_exception.dart';
import 'package:todo_backend/repositories/todo_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getTodos(context),
    HttpMethod.post => _addTodo(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getTodos(RequestContext context) async {
  final todoRepo = context.read<TodoRepository>();

  final todos = await todoRepo.getTodos();

  return Response.json(
    body: todos,
  );
}

Future<Response> _addTodo(RequestContext context) async {
  final todoRepo = context.read<TodoRepository>();

  final body = await context.request.json() as Map<String, dynamic>;

  try {
    final todo = await todoRepo.addTodo(body);

    return Response.json(
      body: todo,
    );
  } on AppException catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'errorMessage': e.message},
    );
  }
}
