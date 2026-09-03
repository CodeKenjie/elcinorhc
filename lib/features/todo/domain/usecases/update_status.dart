import '../repositories/todo_repository.dart';

class UpdateStatus {
  final TodoRepository repository;
  UpdateStatus(this.repository);

  Future<void> call ({ required int id, required bool completed }) {
    return repository.updateTodoStatus(id: id, completed: completed);
  }
}