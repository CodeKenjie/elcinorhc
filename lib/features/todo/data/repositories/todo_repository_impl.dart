import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_sources/todo_local_data_source.dart';
import 'package:elcinorch/core/services/notification_service.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  final NotificationService notificationService;
  TodoRepositoryImpl(this.localDataSource, this.notificationService);

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getTodos();
  }

  @override
  Future<Todo> addTodo({
    int? planId,
    required String title,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? expiresAt
  }) async {
    final todo = await localDataSource.addTodo(
      planId: planId,
      title: title, 
      startsAt: startsAt,
      endsAt: endsAt,
      expiresAt: expiresAt
    );

    await notificationService.scheduleTaskNotifications(
      todoId: todo.id, 
      title: todo.title,
      startsAt: todo.startsAt,
      endsAt: todo.endsAt,
      expiresAt: todo.expiresAt
    );

    return todo;
  }

  @override
  Future<void> updateTodo({
    int? planId,
    required int id,
    required String title,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? expiresAt
  }) async {
    await localDataSource.updateTodo(
      id: id, 
      planId: planId,
      title: title, 
      startsAt: startsAt,
      endsAt: endsAt,
      expiresAt: expiresAt
    );

    await notificationService.scheduleTaskNotifications(
      todoId: id, 
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      expiresAt: expiresAt
    );
  }

  @override
  Future<void> updateTodoStatus({ required int id, required bool completed }) async {
    await localDataSource.updateTodoStatus(id: id, completed: completed);

    if(completed) {
      await notificationService.cancelTaskNotifications(id);
    } else {
      final todos = await localDataSource.getTodos();

      final todo = todos.firstWhere((todo) => todo.id == id);

      await notificationService.scheduleTaskNotifications(
        todoId: todo.id, 
        title: todo.title,
        startsAt: todo.startsAt,
        endsAt: todo.endsAt,
        expiresAt: todo.expiresAt
      );
    }
  }
  @override
  Future<void> deleteTodo(int id) async {
    await localDataSource.deleteTodo(id);

    await notificationService.cancelTaskNotifications(id);
  }
}