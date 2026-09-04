import '../core/database/local/local_database.dart';
import '../features/todo/presentation/controllers/todo_controller.dart';
import '../features/todo/data/data_sources/todo_local_data_source.dart';
import '../features/todo/data/repositories/todo_repository_impl.dart';
import '../features/todo/domain/usecases/add.dart';
import '../features/todo/domain/usecases/get_all.dart';
import '../features/todo/domain/usecases/update.dart';
import '../features/todo/domain/usecases/update_status.dart';
import '../features/todo/domain/usecases/delete.dart';

import '../features/plan/presentation/controller/plan_controller.dart';
import '../features/plan/data/data_sources/plan_local_data_source.dart';
import '../features/plan/data/repositories/plan_repository_impl.dart';
import '../features/plan/domain/usecases/create_plan.dart';
import '../features/plan/domain/usecases/get_plans.dart';
import '../features/plan/domain/usecases/update_plan.dart';
import '../features/plan/domain/usecases/update_plan_status.dart';
import '../features/plan/domain/usecases/delete_plan.dart';

class AppDependencies {
  static final localDatabase = LocalDatabase();

  static final todoLocalDataSource = TodoLocalDataSource(localDatabase);
  static final todoRepository = TodoRepositoryImpl(todoLocalDataSource);
  static final getAllTodoUseCase = GetAll(todoRepository);
  static final addTodoUseCase = Add(todoRepository);
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

  static final planLocalDataSoure = PlanLocalDataSource(localDatabase);
  static final planRepository = PlanRepositoryImpl(planLocalDataSoure);
  static final getPlansUseCase = GetPlans(planRepository);
  static final createPlanUseCase = CreatePlan(planRepository);
  static final updatePlanUseCase = UpdatePlan(planRepository);
  static final updatePlanStatusUseCase = UpdatePlanStatus(planRepository);
  static final deletePlanUseCase = DeletePlan(planRepository);

  static final planController = PlanController(
    getPlansUseCase: getPlansUseCase, 
    createPlanUseCase: createPlanUseCase, 
    updatePlanUseCase: updatePlanUseCase, 
    updatePlanStatusUseCase: updatePlanStatusUseCase, 
    deletePlanUseCase: deletePlanUseCase
  );
}