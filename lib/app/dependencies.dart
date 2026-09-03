import '../core/database/local/local_database.dart';
import '../features/todo/presentation/controllers/todo_controller.dart';
import '../features/todo/data/data_sources/todo_local_data_source.dart';
import '../features/todo/data/repositories/todo_repository_impl.dart';
import '../features/todo/domain/usecases/add.dart';
import '../features/todo/domain/usecases/get_all.dart';
import '../features/todo/domain/usecases/update.dart';
import '../features/todo/domain/usecases/update_status.dart';
import '../features/todo/domain/usecases/delete.dart';

class AppDependencies {
  static final localDatabase = LocalDatabase();
  static final todoRemoteDataSource = TodoLocalDataSource(localDatabase);
  static final todoRepository = TodoRepositoryImpl(todoRemoteDataSource);
  static final addTodoUseCase = Add(todoRepository);
  static final getAllTodoUseCase = GetAll(todoRepository);
  static final updateTodoUseCase = Update(todoRepository);
  static final updateTodoStatusUseCase = UpdateStatus(todoRepository);
  static final deleteTodoUseCase = Delete(todoRepository);

  static final todoController = TodoController(
    addUseCase: addTodoUseCase, 
    getAllUseCase: getAllTodoUseCase, 
    updateStatusUseCase: updateTodoStatusUseCase, 
    updateUseCase: updateTodoUseCase, 
    deleteUseCase: deleteTodoUseCase
  );
}