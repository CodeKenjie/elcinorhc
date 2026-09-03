import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  
  Future<Todo> addTodo({ required String title, DateTime? expiresAt });
  
  Future<void> updateTodo({ required int id, required String title, DateTime? expiresAt });

  Future<void> updateTodoStatus({ required int id, required bool completed });

  Future<void> deleteTodo(int id);
}