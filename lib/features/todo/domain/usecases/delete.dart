import '../repositories/todo_repository.dart';

class Delete {
  final TodoRepository repository;
  const Delete(this.repository);

  Future<void> call (int id) {
    return repository.deleteTodo(id);
  }
}