import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.planId,
    required super.title,
    required super.startsAt,
    required super.endsAt,
    required super.expiresAt,
    required super.completed,
    required super.completedAt,
    required super.createdAt,
  });

  factory TodoModel.fromEntity(Todo todo){
    return TodoModel(
      id: todo.id,
      planId: todo.planId,
      title: todo.title,
      startsAt: todo.startsAt,
      endsAt: todo.endsAt,
      expiresAt: todo.expiresAt,
      completed: todo.completed,
      completedAt: todo.completedAt,
      createdAt: todo.createdAt,
    );
  }
}