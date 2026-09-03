import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_sources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getTodos();
  }

  @override
  Future<Todo> addTodo({
    required String title,
    DateTime? expiresAt
  }) async {
    return await localDataSource.addTodo(title: title, expiresAt: expiresAt);
  }

  @override
  Future<void> updateTodo({
    required int id,
    required String title,
    DateTime? expiresAt
  }) {
    return localDataSource.updateTodo(id: id, title: title, expiresAt: expiresAt);
  }

  @override
  Future<void> updateTodoStatus({ required int id, required bool completed }) {
    return localDataSource.updateTodoStatus(id: id, completed: completed);
  }
  @override
  Future<void> deleteTodo(int id) {
    return localDataSource.deleteTodo(id);
  }
}