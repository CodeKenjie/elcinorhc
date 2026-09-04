import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.planId,
    required super.title,
    required super.completed,
    required super.createdAt,
    required super.expiresAt
  });

  factory TodoModel.fromEntity(Todo todo){
    return TodoModel(
      id: todo.id,
      planId: todo.planId,
      title: todo.title,
      completed: todo.completed,
      createdAt: todo.createdAt,
      expiresAt: todo.expiresAt
    );
  }
}