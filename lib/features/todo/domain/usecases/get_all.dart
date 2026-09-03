import '../repositories/todo_repository.dart';
import '../entities/todo.dart';

class GetAll {
  final TodoRepository repository;
  const GetAll(this.repository);

  Future<List<Todo>> call () {
    return repository.getTodos();
  }
}
