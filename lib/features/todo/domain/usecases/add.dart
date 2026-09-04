import '../repositories/todo_repository.dart';
import '../entities/todo.dart';
class Add {
  final TodoRepository repository;

  const Add(this.repository);

  Future<Todo> call ({ int? planId, required String title, DateTime? expiresAt }) {
    return repository.addTodo(planId: planId, title: title, expiresAt: expiresAt );
  }
}