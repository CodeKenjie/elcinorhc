import '../repositories/todo_repository.dart';
import '../entities/todo.dart';
class Add {
  final TodoRepository repository;

  const Add(this.repository);

  Future<Todo> call ({ required String title, DateTime? expiresAt }) {
    return repository.addTodo(title: title, expiresAt: expiresAt );
  }
}