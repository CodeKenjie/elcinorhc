import '../repositories/todo_repository.dart';

class Update {
  final TodoRepository repository;

  const Update(this.repository);
  Future<void> call({required int id, required String title, DateTime? expiresAt }) {
    return repository.updateTodo(id: id, title: title, expiresAt: expiresAt);
  }
}
