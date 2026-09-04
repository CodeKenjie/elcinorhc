import '../model/todo_model.dart';
import '../../../../core/database/local/local_database.dart';
import 'package:drift/drift.dart';

class TodoLocalDataSource {
  final LocalDatabase localDatabase;

  TodoLocalDataSource(this.localDatabase);

  Future<List<TodoModel>> getTodos() async {
    final todos = await localDatabase.select(localDatabase.todos).get();
    return todos.map((todo) => TodoModel(
      id: todo.id, 
      planId: todo.id, 
      title: todo.title, 
      completed: todo.completed, 
      createdAt: todo.createdAt, 
      expiresAt: todo.expiresAt
    )).toList();
  }

  Future<TodoModel> addTodo({
    int? planId,
    required String title,
    DateTime? expiresAt
  }) async {
    final id = await localDatabase.into(localDatabase.todos).insert(
      TodosCompanion.insert(
        planId: Value(planId),
        title: title,
        expiresAt: Value(expiresAt),
      )
    );

    final todo = await (localDatabase.select(localDatabase.todos)..where((todo) => todo.id.equals(id))).getSingle();

    return TodoModel(
      id: todo.id, 
      planId: todo.id, 
      title: todo.title, 
      completed: todo.completed, 
      createdAt: todo.createdAt, 
      expiresAt: todo.expiresAt
    );
  }

  Future<int> updateTodo({required int id, int? planId, required String title, DateTime? expiresAt}){
    return (localDatabase.update(localDatabase.todos)..where((todo) => todo.id.equals(id))).write(
      TodosCompanion(
        planId: Value(planId),
        title: Value(title),
        expiresAt: Value(expiresAt)
      )
    );
  }

  Future<int> updateTodoStatus({ required int id, required bool completed }) {
    return (localDatabase.update(localDatabase.todos)..where((todo) => todo.id.equals(id))).write(
      TodosCompanion( completed: Value(completed) )
    );
  }

  Future<int> deleteTodo(int id){
    return (localDatabase.delete(localDatabase.todos)..where((todo) => todo.id.equals(id))).go();
  }
}